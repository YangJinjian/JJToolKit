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
    
    func launch(adImage image: UIImage, waitTime time: CGFloat,
                canSkip skip: Bool, canTouch touch: Bool) -> JJAdView {
        let adView = JJAdView(image: image, waitTime: time, canSkip: skip, canTouch: touch)
        return adView
    }
    
    func show(ad: JJAdView) {
        if let window = UIApplication.shared.keyWindow {
            window.addSubview(ad)
        }
    }
    
}

