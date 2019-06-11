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
    
    // 根据AdModel生成广告图
    // model: AdModel
    func launch(imageModel model: JJAdModel) {
        if let key = model.cacheKey {
            JJAdCache.shared.findAdImage(withKey: key, success: { image in
                self.launch(adImage: image, waitTime: model.waitTime, canSkip: model.canSkip, canTouch: model.canTouch)
            }) {
                self.removeAdInfo(withKey: key)
            }
            return
        }
        var startTime = "", endTime = ""
        let waitTime = "\(model.waitTime)"
        let canSkip = model.canSkip ? "1" : "0"
        let canTouch = model.canTouch ? "1" : "0"
        if let start = model.startTime, let end = model.endTime {
            startTime = "\(start)"
            endTime = "\(end)"
        }
        if let imageName = model.imageName {
            let key = imageName.md5()
            JJAdCache.shared.findAdImage(withKey: key, success: { image in
                self.launch(adImage: image, waitTime: model.waitTime, canSkip: model.canSkip, canTouch: model.canTouch)
            }) {
                if let image = UIImage(named: imageName) {
                    JJAdCache.shared.store(image: image, forKey: key)
                    self.storeAdInfo(withKey: key, waitTime: waitTime,
                                     startTime: startTime, endTime: endTime,
                                     canSkip: canSkip, canTouch: canTouch)
                    self.launch(adImage: image, waitTime: model.waitTime,
                                canSkip: model.canSkip, canTouch: model.canTouch)
                }
            }
        }
        if let imageUrl = model.imageUrlStr {
            let key = imageUrl.md5()
            JJAdCache.shared.findAdImage(withKey: key, success: { image in
                self.launch(adImage: image, waitTime: model.waitTime, canSkip: model.canSkip, canTouch: model.canTouch)
            }) {
                JJAdCache.shared.fetchWebImage(withURL: imageUrl) { image in
                    self.storeAdInfo(withKey: key, waitTime: waitTime,
                                     startTime: startTime, endTime: endTime,
                                     canSkip: canSkip, canTouch: canTouch)
                    if model.showType == .showWhenCached {
                        self.launch(adImage: image, waitTime: model.waitTime,
                                    canSkip: model.canSkip, canTouch: model.canTouch)
                    }
                }
            }
        }
        if let videoUrl = model.videoUrlStr {
            storeAdInfo(withKey: videoUrl.md5(), waitTime: waitTime,
                        startTime: startTime, endTime: endTime,
                        canSkip: canSkip, canTouch: canTouch)
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
                             startTime start: String, endTime end: String,
                             canSkip skip: String, canTouch touch: String) {
        var adInfoDict: [String: String] = [:]
        adInfoDict[JJAdInfoDictKey.adCacheKey] = key
        adInfoDict[JJAdInfoDictKey.startTime] = start
        adInfoDict[JJAdInfoDictKey.endTime] = end
        adInfoDict[JJAdInfoDictKey.waitTime] = wait
        adInfoDict[JJAdInfoDictKey.canSkip] = skip
        adInfoDict[JJAdInfoDictKey.canTouch] = touch
        print(adInfoDict)
        var adInfoArray = [adInfoDict]
        if let adSchedulInfo = kUD.object(forKey: JJAdUserDefaultKey.kAdSchedulInfo) as? [[String: String]] {
            adInfoArray += adSchedulInfo
        }
        kUD.setValue(adInfoArray, forKey: JJAdUserDefaultKey.kAdSchedulInfo)
        kUD.synchronize()
    }
    
    private func removeAdInfo(withKey key: String) {
        if let adSchedulInfo = kUD.object(forKey: JJAdUserDefaultKey.kAdSchedulInfo) as? [[String: String]] {
            let newSchedulInfo = adSchedulInfo.filter { dict -> Bool in
                dict[JJAdInfoDictKey.adCacheKey] != key
            }
            kUD.setValue(newSchedulInfo, forKey: JJAdUserDefaultKey.kAdSchedulInfo)
            kUD.synchronize()
        }
    }
    
    // 检查当前时间有没有广告排期
    // 如果当前时间有广告排期，则显示广告
    // 如果某条广告的结束时间早于当前时间，则将该广告删除
    func checkAdSchedulInfo() -> [String: String]? {
        if let adSchedulInfo = kUD.object(forKey: JJAdUserDefaultKey.kAdSchedulInfo) as? [[String: String]] {
            var showArray: [[String: String]] = []
            var deleteArray: [[String: String]] = []
            for dict in adSchedulInfo {
                if let start = dict[JJAdInfoDictKey.startTime], let startTime = Double(start),
                    let end = dict[JJAdInfoDictKey.endTime], let endTime = Double(end) {
                    let formatter = DateFormatter()
                    formatter.dateFormat = "yyyy-MM-dd"
                    print("""
                        ================
                        开始时间\(formatter.string(from: Date(timeIntervalSince1970: startTime)))，
                        当前时间\(formatter.string(from: Date())),
                        结束时间\(formatter.string(from: Date(timeIntervalSince1970: endTime)))
                        """)
                    let currentTime = Date().timeIntervalSince1970
                    if currentTime > endTime {
                        // 该广告已过期，删除该广告
                        deleteArray.append(dict)
                    } else if currentTime > startTime {
                        // 当前时间有广告排期，展示广告
                        showArray.append(dict)
                    }
                }
            }
            // 删除已过期的广告
            if !deleteArray.isEmpty {
                var schedulCopy = adSchedulInfo
                for dict in deleteArray {
                    if let cacheKey = dict[JJAdInfoDictKey.adCacheKey] {
                        JJAdCache.shared.deleteCache(withKey: cacheKey)
                    }
                    schedulCopy = schedulCopy.filter{ $0 != dict }
                }
                kUD.setValue(schedulCopy, forKey: JJAdUserDefaultKey.kAdSchedulInfo)
                kUD.synchronize()
            }
            // 展示广告，如果同一时间段有多个广告图，则随机展示一张
            if !showArray.isEmpty {
                let randomDict = showArray[showArray.count.arc4random]
                if let cacheKey = randomDict[JJAdInfoDictKey.adCacheKey],
                    let touch = randomDict[JJAdInfoDictKey.canTouch],
                    let skip = randomDict[JJAdInfoDictKey.canSkip],
                    let wait = randomDict[JJAdInfoDictKey.waitTime],
                    let waitTime = Float(wait) {
                    let model = JJAdModel(cacheKey: cacheKey,
                                          waitTime: CGFloat(waitTime),
                                          canTouch: touch == "1",
                                          canSkip: skip == "1")
                    launch(imageModel: model)
                }
                return randomDict
            }
        }
        return nil
    }
    


extension JJAdLauncher {
    struct JJAdInfoDictKey {
        static let startTime = "start_time"
        static let endTime = "end_time"
        static let waitTime = "wait_time"
        static let adCacheKey = "ad_cache_key"
        static let canSkip = "can_skip"
        static let canTouch = "can_touch"
    }
    struct JJAdUserDefaultKey {
        static let kAdSchedulInfo = "K_JJ_Ad_Schedule_Info_Array"
    }
}

