//
//  JJAdLauncher.swift
//  JJToolKit
//
//  Created by YangJinjian on 2019/6/5.
//  Copyright © 2019 YangJinjian. All rights reserved.
//

import UIKit

class JJAdLauncher: NSObject {
    
    // 单例化
    static let shared = JJAdLauncher()
    // 防止外部使用init方法初始化
    private override init() {}
    
    // 根据本地图片生成广告图
    // image: 图片
    // time: 等待时间
    // skip: 是否可以跳过
    // touch: 是否可以点击
    func launch(adImage image: UIImage, waitTime time: CGFloat,
                canSkip skip: Bool, canTouch touch: Bool) -> JJAdView {
        let adView = JJAdView(image: image, waitTime: time, canSkip: skip, canTouch: touch)
        return adView
    }
    
    // 根据图片URL生成广告图
    // url: 图片URL
    // time: 等待时间
    // skip: 是否可以跳过
    // touch: 是否可以点击
    func launch(webImage url: String, waitTime time: CGFloat,
                canSkip skip: Bool, canTouch touch: Bool) -> JJAdView? {
        if let image = UIImage(named: "test_mt") {
            let ad = JJAdLauncher.shared.launch(adImage: image, waitTime: 3, canSkip: true, canTouch: true)
            return ad
        }
        return nil
    }
    
    func show(ad: JJAdView) {
        if let window = UIApplication.shared.keyWindow {
            window.addSubview(ad)
        }
    }
    
}

