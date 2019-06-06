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
                canSkip skip: Bool, canTouch touch: Bool) {
        DispatchQueue.main.async {
            let adView = JJAdView(image: image, waitTime: time, canSkip: skip, canTouch: touch)
            self.show(ad: adView)
        }
    }
    
    // 根据图片URL生成广告图
    // url: 图片URL
    // time: 等待时间
    // skip: 是否可以跳过
    // touch: 是否可以点击
    // type: 展示时机
    func launch(webImage url: String, waitTime time: CGFloat,
                canSkip skip: Bool, canTouch touch: Bool,
                showType type: JJWebImageLaunchType) {
        let md5Str = url.md5()
        JJAdCache.shared.findAdImage(withKey: md5Str, success: { image in
            self.launch(adImage: image, waitTime: time, canSkip: skip, canTouch: touch)
        }) {
            JJAdCache.shared.fetchWebImage(withURL: url) { image in
                if type == .showWhenCached {
                    self.launch(adImage: image, waitTime: time, canSkip: skip, canTouch: touch)
                }
            }
        }
    }
    
    func show(ad: JJAdView) {
        if let window = UIApplication.shared.keyWindow {
            window.addSubview(ad)
        }
    }
    
}

extension JJAdLauncher {
    enum JJWebImageLaunchType {
        case showNextTime
        case showWhenCached
    }
}

