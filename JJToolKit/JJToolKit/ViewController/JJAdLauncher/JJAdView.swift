//
//  JJAdView.swift
//  JJToolKit
//
//  Created by YangJinjian on 2019/6/5.
//  Copyright © 2019 YangJinjian. All rights reserved.
//

import UIKit
import SnapKit

class JJAdView: UIView {
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        // 广告ImageView
        let imageView = UIImageView(frame: .zero)
        adImageView = imageView
        self.addSubview(adImageView)
        // 跳过按钮
        let button = UIButton(type: .custom)
        button.addTarget(self, action: #selector(skip), for: .touchUpInside)
        button.backgroundColor = .red
        button.setTitle("跳过", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        skipButton = button
        self.addSubview(skipButton)
        // 添加点击手势
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(adTouched(tap:)))
        self.addGestureRecognizer(tapGesture)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - Init with image/time
    private(set) var adImage: UIImage?
    private var adImageView: UIImageView!
    private(set) var waitTime: CGFloat = 3
    convenience init(image: UIImage, waitTime: CGFloat) {
        self.init(frame: kScreenBounds)
        self.adImage = image
        self.waitTime = waitTime
    }
    // MARK: - Init with image/time/skip/touch
    private(set) var canSkip: Bool = false
    private var skipButton: UIButton!
    private(set) var canTouch: Bool = false
    private var tapGesture: UITapGestureRecognizer!
    convenience init(image: UIImage, waitTime: CGFloat, canSkip: Bool, canTouch: Bool) {
        self.init(image: image, waitTime: waitTime)
        self.canSkip = canSkip
        self.canTouch = canTouch
    }
    // MARK: - LayoutSubviews
    override func layoutSubviews() {
        super.layoutSubviews()
        // 广告ImageView
        adImageView.image = adImage
        adImageView.snp.makeConstraints { (cons) in
            cons.top.bottom.leading.trailing.equalToSuperview()
        }
        // 跳过按钮
        if canSkip {
            skipButton.snp.makeConstraints { (cons) in
                cons.trailing.equalToSuperview().offset(JJAdViewConstant.skipButtonTrailing)
                cons.top.equalToSuperview().offset(JJAdViewConstant.skipButtonTop)
                cons.width.equalTo(JJAdViewConstant.skipButtonWidth)
                cons.height.equalTo(JJAdViewConstant.skipButtonHeight)
            }
        }
        // 点击手势
        tapGesture.isEnabled = canTouch
    }
    // MARK: - Functions
    // 跳过广告
    // 执行动画移出屏幕，动画结束时removeFromSuperview并发送移除通知
    @objc private func skip() {
        UIView.animate(withDuration: 0.2, animations: {
            self.frame = CGRect(x: -kScreenWidth, y: self.frame.origin.y,
                                width: self.bounds.width, height: self.bounds.height)
        }) { finished in
            if finished {
                self.removeFromSuperview()
                kNC.post(name: JJAdNotificationName.adDidRemoved, object: nil)
            }
        }
    }
    // 响应广告点击
    @objc private func adTouched(tap: UITapGestureRecognizer) {
        switch tap.state {
        case .recognized:
            kNC.post(name: JJAdNotificationName.adDidTapped, object: nil)
        default:
            return
        }
    }
}

extension JJAdView {
    struct JJAdViewConstant {
        static let skipButtonWidth = 30
        static let skipButtonHeight = 30
        static let skipButtonTop = isFullScreenDevice ? 60 : 20
        static let skipButtonTrailing = -20
    }
    struct JJAdNotificationName {
        // 当广告从keyWindow移除时发送该通知
        static let adDidRemoved = NSNotification.Name(rawValue: "JJ_Ad_Did_Removed_From_Superview")
        // 点击广告时发送该通知
        static let adDidTapped = NSNotification.Name(rawValue: "JJ_Ad_Did_Tapped")
    }
}
