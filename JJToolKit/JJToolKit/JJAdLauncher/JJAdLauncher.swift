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
    private func launch(adImage image: UIImage, waitTime time: CGFloat,
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
    private func launch(webImage url: String, waitTime time: CGFloat,
                canSkip skip: Bool, canTouch touch: Bool,
                showType type: JJWebImageLaunchType) {
        
    }
    
    // 根据AdModel生成广告图
    // model: AdModel
    // time: 等待时间
    // skip: 是否可以跳过
    // touch: 是否可以点击
    // type: 展示时机
    func launch(imageModel model: JJAdModel, waitTime time: CGFloat,
                canSkip skip: Bool, canTouch touch: Bool,
                showType type: JJWebImageLaunchType) {
        var startTime = "", endTime = "", waitTime = ""
        if let start = model.startTime, let end = model.endTime, let wait = model.waitTime {
            startTime = "\(start)"
            endTime = "\(end)"
            waitTime = "\(wait)"
        }
        if let imageName = model.imageName {
            let key = imageName.md5()
            JJAdCache.shared.findAdImage(withKey: key, success: { image in
                self.launch(adImage: image, waitTime: time, canSkip: skip, canTouch: touch)
            }) {
                if let image = UIImage(named: imageName) {
                    JJAdCache.shared.store(image: image, forKey: key)
                    self.storeAdInfo(withKey: key, waitTime: waitTime, startTime: startTime, endTime: endTime)
                    self.launch(adImage: image, waitTime: time, canSkip: skip, canTouch: touch)
                }
            }
        }
        if let imageUrl = model.imageUrlStr {
            let key = imageUrl.md5()
            JJAdCache.shared.findAdImage(withKey: key, success: { image in
                self.launch(adImage: image, waitTime: time, canSkip: skip, canTouch: touch)
            }) {
                JJAdCache.shared.fetchWebImage(withURL: imageUrl) { image in
                    self.storeAdInfo(withKey: key, waitTime: waitTime, startTime: startTime, endTime: endTime)
                    if type == .showWhenCached {
                        self.launch(adImage: image, waitTime: time, canSkip: skip, canTouch: touch)
                    }
                }
            }
        }
        if let videoUrl = model.videoUrlStr {
            storeAdInfo(withKey: videoUrl.md5(), waitTime: waitTime, startTime: startTime, endTime: endTime)
        }
    }
    
    // 将广告显示到KeyWindow上
    func show(ad: JJAdView) {
        if let window = UIApplication.shared.keyWindow {
            window.addSubview(ad)
            kNC.post(name: JJAdNotificationName.adDidShow, object: nil)
        }
    }
    
    // 将广告信息保存至UserDefault中
    private func storeAdInfo(withKey key: String, waitTime wait: String,
                             startTime start: String, endTime end: String) {
        var adInfoDict: [String: String] = [:]
        adInfoDict[JJAdInfoDictKey.adCacheKey] = key
        adInfoDict[JJAdInfoDictKey.startTime] = start
        adInfoDict[JJAdInfoDictKey.endTime] = end
        adInfoDict[JJAdInfoDictKey.waitTime] = wait
        print(adInfoDict)
        var adInfoArray = [adInfoDict]
        if let adSchedulInfo = kUD.object(forKey: JJAdUserDefaultKey.kAdSchedulInfo) as? [[String: String]] {
            adInfoArray += adSchedulInfo
        }
        kUD.setValue(adInfoArray, forKey: JJAdUserDefaultKey.kAdSchedulInfo)
        kUD.synchronize()
    }
    
}

extension JJAdLauncher {
    enum JJWebImageLaunchType {
        case showNextTime
        case showWhenCached
    }
    struct JJAdInfoDictKey {
        static let startTime = "start_time"
        static let endTime = "end_time"
        static let waitTime = "wait_time"
        static let adCacheKey = "ad_cache_key"
    }
    struct JJAdUserDefaultKey {
        static let kAdSchedulInfo = "K_JJ_Ad_Schedule_Info_Array"
    }
}

