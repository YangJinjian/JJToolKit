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
    
    var placeholderView: UIView!
    var adImageBottomSpace: CGFloat = 0
}
