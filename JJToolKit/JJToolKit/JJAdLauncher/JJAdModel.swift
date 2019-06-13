//
//  JJAdModel.swift
//  JJToolKit
//
//  Created by YangJinjian on 2019/6/10.
//  Copyright © 2019 YangJinjian. All rights reserved.
//

import UIKit

struct JJAdModel {
    // imageName: 图片文件名
    // imageUrlStr: 图片地址
    // videoName: 视频文件名
    // videoUrlStr: 视频地址
    // cacheKey: 缓存Key
    private(set) var imageName: String?
    private(set) var imageUrlStr: String?
    private(set) var videoName: String?
    private(set) var videoUrlStr: String?
    private(set) var cacheKey: String?
    // startTime: 开始时间
    // endTime: 结束时间
    private(set) var startTime: TimeInterval?
    private(set) var endTime: TimeInterval?
    // waitTime: 等待时间
    // canTouch: 是否可以点击
    // canSkip: 是否可以跳过
    private(set) var waitTime: CGFloat = 5
    private(set) var canTouch: Bool = false
    private(set) var canSkip: Bool = false
    // showType: 展示时机
    private(set) var showType: JJWebMediaLaunchType = .showWhenCached
    
    private init(startTime: TimeInterval?, endTime: TimeInterval?,
                 waitTime: CGFloat = 5, canTouch: Bool = false, canSkip: Bool = false,
                 showType: JJWebMediaLaunchType = .showWhenCached) {
        self.startTime = startTime
        self.endTime = endTime
        self.waitTime = waitTime
        self.canTouch = canTouch
        self.canSkip = canSkip
        self.showType = showType
    }
    
    init(imageName: String?,
         startTime: TimeInterval?, endTime: TimeInterval?, waitTime: CGFloat = 5,
         canTouch: Bool = false, canSkip: Bool = false,
         showType: JJWebMediaLaunchType = .showWhenCached) {
        self.init(startTime: startTime, endTime: endTime, waitTime: waitTime,
                  canTouch: canTouch, canSkip: canSkip, showType: showType)
        self.imageName = imageName
    }
    
    init(imageUrlStr: String?,
         startTime: TimeInterval?, endTime: TimeInterval?, waitTime: CGFloat = 5,
         canTouch: Bool = false, canSkip: Bool = false,
         showType: JJWebMediaLaunchType = .showWhenCached) {
        self.init(startTime: startTime, endTime: endTime, waitTime: waitTime,
                  canTouch: canTouch, canSkip: canSkip, showType: showType)
        self.imageUrlStr = imageUrlStr
    }
    
    init(videoName: String?,
         startTime: TimeInterval?, endTime: TimeInterval?, waitTime: CGFloat = 5,
         canTouch: Bool = false, canSkip: Bool = false,
         showType: JJWebMediaLaunchType = .showWhenCached) {
        self.init(startTime: startTime, endTime: endTime, waitTime: waitTime,
                  canTouch: canTouch, canSkip: canSkip, showType: showType)
        self.videoName = videoName
    }
    
    init(videoUrlStr: String?,
         startTime: TimeInterval?, endTime: TimeInterval?, waitTime: CGFloat = 5,
         canTouch: Bool = false, canSkip: Bool = false,
         showType: JJWebMediaLaunchType = .showWhenCached) {
        self.init(startTime: startTime, endTime: endTime, waitTime: waitTime,
                  canTouch: canTouch, canSkip: canSkip, showType: showType)
        self.videoUrlStr = videoUrlStr
    }
    
    init(cacheKey: String?,
         waitTime: CGFloat = 5, canTouch: Bool = false, canSkip: Bool = false) {
        self.init(startTime: nil, endTime: nil, waitTime: waitTime, canTouch: canTouch, canSkip: canSkip)
        self.cacheKey = cacheKey
    }
}

enum JJWebMediaLaunchType: Int {
    case showNow
    case showNextTime
    case showWhenCached
}
