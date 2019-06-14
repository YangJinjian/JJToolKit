//
//  JJAdViewController.swift
//  JJToolKit
//
//  Created by YangJinjian on 2019/6/13.
//  Copyright © 2019 YangJinjian. All rights reserved.
//

import UIKit
import UICircularProgressRing
import SnapKit
import Player

class JJAdViewController: UIViewController {
    
    // UI
    @IBOutlet weak private var adImageView: UIImageView!
    @IBOutlet weak private var centerLogo: UIImageView!
    @IBOutlet weak private var bottomLogo: UIImageView!
    @IBOutlet weak private var logoWidth: NSLayoutConstraint!
    @IBOutlet weak private var logoTop: NSLayoutConstraint!
    @IBOutlet weak private var skipView: UIView!
    @IBOutlet weak private var skipButton: UIButton!
    private var progressView: UICircularProgressRing!
    private var videoPlayer: Player!
    
    private(set) var adImage: UIImage! {
        didSet {
            // 等比例缩放图片，并展示Image
            if adImage != nil {
                resetLogo()
                adImageView.image = adImage.scaleImage(scale: kScreenWidth / adImage.size.width)
            }
        }
    }
    private(set) var videoPath: String! {
        didSet {
            if videoPath != nil {
                resetLogo()
                self.perform(#selector(playVideo), with: nil, afterDelay: 0.1)
            }
        }
    }
    private(set) var waitTime: CGFloat = 5 {
        didSet {
            self.perform(#selector(startProgressAnimation), with: nil, afterDelay: 0.1)
        }
    }
    private(set) var canSkip: Bool = false {
        didSet {
            skipView.isHidden = !canSkip
        }
    }
    private var tapGesture: UITapGestureRecognizer!
    private(set) var canTouch: Bool = false {
        didSet {
            tapGesture.isEnabled = canTouch
        }
    }

    // 生命周期
    override func viewDidLoad() {
        super.viewDidLoad()
        // 根据是否有图片修正部分约束
        // 中心Logo上边缘位于屏幕的40%
        // Logo宽度为屏幕宽度的74%
        logoTop.constant = kScreenHeight * 0.4
        logoWidth.constant = kScreenWidth * 0.74
        centerLogo.isHidden = false
        bottomLogo.isHidden = true
        // 添加点击手势
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(adTouched(tap:)))
        self.view.addGestureRecognizer(tapGesture)
        // 跳过按钮圆形进度条
        skipView.layer.cornerRadius = JJAdConfig.shared.skipWidth / 2
        let ring = UICircularProgressRing()
        ring.shouldShowValueText = false
        ring.style = .ontop
        ring.animationTimingFunction = .linear // 动画时间线
        ring.outerRingWidth = 2
        ring.outerRingColor = .clear
        ring.innerRingWidth = 2
        ring.innerRingColor = UIColor.colorWithHexString("#FF6100")
        ring.startAngle = 270
        ring.endAngle = 270
        progressView = ring
        skipView.addSubview(progressView)
        progressView.snp.makeConstraints { (cons) in
            cons.top.bottom.leading.trailing.equalToSuperview()
        }
        skipView.isHidden = true
        // 视频播放器
        videoPlayer = Player()
        videoPlayer.playerDelegate = self
        videoPlayer.playbackDelegate = self
        videoPlayer.fillMode = .resize
        self.addChild(videoPlayer)
        self.view.insertSubview(videoPlayer.view, belowSubview: skipView)
        videoPlayer.view.snp.makeConstraints { (cons) in
            cons.top.leading.trailing.equalToSuperview()
            cons.bottom.equalToSuperview().offset(-100)
        }
        videoPlayer.didMove(toParent: self)
    }
    
    // MARK: - Functions
    // 跳过广告
    // 执行动画移出屏幕，动画结束时removeFromSuperview并发送移除通知
    @IBAction private func skip() {
        UIView.animate(withDuration: 0.2, animations: {
            self.view.frame = CGRect(x: -kScreenWidth, y: self.view.frame.origin.y,
                                width: self.view.bounds.width, height: self.view.bounds.height)
        }) { finished in
            if finished {
                self.view.removeFromSuperview()
                self.removeFromParent()
                JJAdLauncher.shared.adDidRemoved()
                print("JJAdNotificationName:adDidRemoved")
                kNC.post(name: JJAdNotificationName.adDidRemoved, object: nil)
            }
        }
    }
    
    // 响应广告点击
    @objc private func adTouched(tap: UITapGestureRecognizer) {
        switch tap.state {
        case .recognized:
            print("JJAdNotificationName:adDidTapped")
            kNC.post(name: JJAdNotificationName.adDidTapped, object: nil)
        default:
            return
        }
    }
    
    // 重制广告相关参数
    func reset(image: UIImage?, videoPath: String?, waitTime: CGFloat, canSkip: Bool, canTouch: Bool) {
        self.adImage = image
        self.videoPath = videoPath
        self.waitTime = waitTime
        self.canSkip = canSkip
        self.canTouch = canTouch
    }
    
    @objc private func startProgressAnimation() {
        if progressView != nil {
            progressView.startProgress(to: 100, duration: Double(waitTime)) { [weak self] in
                self?.skip()
            }
        }
    }
    
    private func resetLogo() {
        if adImage == nil && videoPath == nil {
            centerLogo.isHidden = false
            bottomLogo.isHidden = true
        } else {
            centerLogo.isHidden = true
            bottomLogo.isHidden = false
        }
    }
    
    @objc private func playVideo() {
        videoPlayer.url = URL(fileURLWithPath: videoPath)
        videoPlayer.playFromBeginning()
    }
}

extension JJAdViewController: PlayerDelegate {
    func playerReady(_ player: Player) {
        print("Ready")
    }
    
    func playerPlaybackStateDidChange(_ player: Player) {
        print("PlaybackStateDidChange")
    }
    
    func playerBufferingStateDidChange(_ player: Player) {
        print("BufferingStateDidChange")
    }
    
    func playerBufferTimeDidChange(_ bufferTime: Double) {
        print("BufferTimeDidChange")
    }
    
    func player(_ player: Player, didFailWithError error: Error?) {
        print("didFailWithError")
        print(error.debugDescription)
    }
}

extension JJAdViewController: PlayerPlaybackDelegate {
    func playerCurrentTimeDidChange(_ player: Player) {
        print("CurrentTimeDidChange")
    }
    
    func playerPlaybackWillStartFromBeginning(_ player: Player) {
        print("PlaybackWillStartFromBeginning")
    }
    
    func playerPlaybackDidEnd(_ player: Player) {
        print("PlaybackDidEnd")
    }
    
    func playerPlaybackWillLoop(_ player: Player) {
        print("PlaybackWillLoop")
    }
}

struct JJAdNotificationName {
    // 当广告添加到KeyWindow时发送该通知
    static let adDidShow = NSNotification.Name(rawValue: "JJ_Ad_Did_Show")
    // 当广告从KeyWindow移除时发送该通知
    static let adDidRemoved = NSNotification.Name(rawValue: "JJ_Ad_Did_Removed_From_Key_Window")
    // 点击广告时发送该通知
    static let adDidTapped = NSNotification.Name(rawValue: "JJ_Ad_Did_Tapped")
}
