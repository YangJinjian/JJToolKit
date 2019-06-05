//
//  JJCommonConstant.swift
//  JJToolKit
//
//  Created by YangJinjian on 2019/6/5.
//  Copyright © 2019 YangJinjian. All rights reserved.
//

import UIKit

let kFM = FileManager.default
let kUD = UserDefaults.standard
let kNC = NotificationCenter.default
let kBundle = Bundle.main
let kVersion = kBundle.infoDictionary!["CFBundleVersion"] as! String
let kBuild = kBundle.infoDictionary!["CFBundleShortVersionString"] as! String
// 文件根路径
let docDir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
let docURL = kFM.urls(for: .documentDirectory, in: .userDomainMask)[0]
// 当前时间戳
let kTime = String(Int(Date().timeIntervalSince1970))
