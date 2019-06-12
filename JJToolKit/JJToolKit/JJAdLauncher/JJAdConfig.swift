//
//  JJAdConfig.swift
//  JJToolKit
//
//  Created by YangJinjian on 2019/6/12.
//  Copyright © 2019 YangJinjian. All rights reserved.
//

import UIKit

class JJAdConfig: NSObject {
    // 单例化
    static let shared = JJAdConfig()
    // 防止外部使用init方法初始化
    private override init() {}
    // 占位图
    var placeholderView: UIView!
    // 广告图距离底部高度
    var adImageBottomSpace: CGFloat = 0
    // 跳过按钮相关
    var skipWidth: CGFloat = 35
    var skipHeight: CGFloat = 35
    var skipTop: CGFloat = isFullScreenDevice ? 65 : 25
    var skipTrailing: CGFloat = -30
}
