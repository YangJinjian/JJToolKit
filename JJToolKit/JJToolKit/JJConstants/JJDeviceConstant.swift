//
//  JJDeviceConstant.swift
//  JJToolKit
//
//  Created by YangJinjian on 2019/6/5.
//  Copyright © 2019 YangJinjian. All rights reserved.
//

import UIKit

// 设备相关
let kDevice = UIDevice.current
let kSystemName = kDevice.systemName
let kSystemVersion = kDevice.systemVersion
// 屏幕分辨率相关
let kScreenBounds = UIScreen.main.bounds
let kScreenSize = kScreenBounds.size
let kScreenWidth = kScreenSize.width
let kScreenHeight = kScreenSize.height
let kScreenScale = UIScreen.main.scale
let kResolutionWidth = kScreenWidth * kScreenScale
let kResolutionHeight = kScreenHeight * kScreenScale
let kResolution = CGSize(width: kResolutionWidth, height: kResolutionHeight)
// 判断屏幕尺寸
let is35Inch = kResolution == CGSize(width: 640, height: 960)
let is40Inch = kResolution == CGSize(width: 640, height: 1136)
let is47Inch = kResolution == CGSize(width: 750, height: 1334)
let is55Inch = kResolution == CGSize(width: 1242, height: 2208)
let is58Inch = kResolution == CGSize(width: 1125, height: 2436)
let is61Inch = kResolution == CGSize(width: 828, height: 1792)
let is65Inch = kResolution == CGSize(width: 1242, height: 2688)
// 判断是否为全面屏
let isFullScreenDevice = is58Inch || is61Inch || is65Inch
// 状态栏
let kStatusBarHeight = UIApplication.shared.statusBarFrame.size.height
