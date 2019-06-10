//
//  JJAdModel.swift
//  JJToolKit
//
//  Created by YangJinjian on 2019/6/10.
//  Copyright © 2019 YangJinjian. All rights reserved.
//

import UIKit

struct JJAdModel {
    private(set) var imageName: String?
    private(set) var imageUrlStr: String?
    private(set) var videoUrlStr: String?
    private(set) var startTime: TimeInterval?
    private(set) var endTime: TimeInterval?
    private(set) var waitTime: Int?
    
    private init(startTime: TimeInterval?, endTime: TimeInterval?, waitTime: Int? = 5) {
        self.startTime = startTime
        self.endTime = endTime
        self.waitTime = waitTime
    }
    
    init(imageName: String?, startTime: TimeInterval?, endTime: TimeInterval?, waitTime: Int? = 5) {
        self.init(startTime: startTime, endTime: endTime, waitTime: waitTime)
        self.imageName = imageName
    }
    
    init(imageUrlStr: String?, startTime: TimeInterval?, endTime: TimeInterval?, waitTime: Int? = 5) {
        self.init(startTime: startTime, endTime: endTime, waitTime: waitTime)
        self.imageUrlStr = imageUrlStr
    }
    
    init(videoUrlStr: String?, startTime: TimeInterval?, endTime: TimeInterval?, waitTime: Int? = 5) {
        self.init(startTime: startTime, endTime: endTime, waitTime: waitTime)
        self.videoUrlStr = videoUrlStr
    }
}
