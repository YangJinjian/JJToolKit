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
        if let placeholder = JJAdConfig.shared.placeholderView {
            self.addSubview(placeholder)
        }
        // 广告ImageView
        let imageView = UIImageView(frame: .zero)
        // 裁剪UIImage防止图片变形
        imageView.contentMode = .top
        imageView.layer.masksToBounds = true
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
    private(set) var adImage: UIImage!
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
        let adImageSize = CGSize(width: kScreenWidth, height: kScreenHeight - JJAdConfig.shared.adImageBottomSpace)
        adImageView.image = scaleImage(adImage, toFitSize: adImageSize)
        adImageView.snp.makeConstraints { (cons) in
            cons.top.leading.trailing.equalToSuperview()
            cons.bottom.equalToSuperview().offset(-JJAdConfig.shared.adImageBottomSpace)
        }
        // 跳过按钮
        if canSkip {
            skipButton.snp.makeConstraints { (cons) in
                cons.trailing.equalToSuperview().offset(JJAdConfig.shared.skipTrailing)
                cons.top.equalToSuperview().offset(JJAdConfig.shared.skipTop)
                cons.width.equalTo(JJAdConfig.shared.skipWidth)
                cons.height.equalTo(JJAdConfig.shared.skipHeight)
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
    // 缩放/裁剪图片适应新的size
    private func scaleImage(_ image: UIImage, toFitSize size: CGSize) -> UIImage? {
//        print(image.size, size)
        // 优先适配图片宽度
        // 在宽度合适的情况下，如果高度大于所需尺寸，则裁切掉图片底部
        // 在宽度合适的情况下，如果高度小于所需尺寸，则改为适配图片高度，并裁切掉图片两侧
        var scale = size.width / image.size.width
        let fitHeight = image.size.height * size.width / image.size.width
        if fitHeight < size.height {
            // 适配图片高度
            scale = size.height / image.size.height
        }
        if let newImage = image.scaleImage(scale: scale) {
//            print(newImage.size)
            return newImage
        }
        return nil
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
