//
//  JJAdCache.swift
//  JJToolKit
//
//  Created by YangJinjian on 2019/6/6.
//  Copyright © 2019 YangJinjian. All rights reserved.
//

import UIKit
import Kingfisher
import CryptoSwift

class JJAdCache: NSObject {
    
    // 单例化
    static let shared = JJAdCache()
    private let cache = ImageCache(name: "JJAdImageCache")
    // 防止外部使用init方法初始化
    private override init() {}
    
    func findAdImage(withKey key: String, success: @escaping(UIImage)->(), failure: @escaping()->()) {
        if cache.isCached(forKey: key) {
            cache.retrieveImage(forKey: key) { result in
                switch result {
                case .success(let value):
                    if let image = value.image {
                        success(image)
                    }
                case .failure(let error):
                    print("从JJAdCache加载图片失败：\(error)")
                    failure()
                }
            }
        } else {
            print("JJAdCache没有缓存过该图片")
            failure()
        }
    }
    
    func fetchWebImage(withURL urlStr: String, success: @escaping(UIImage)->()) {
        let md5Str = urlStr.md5()
        if let url = URL(string: urlStr) {
            let downloader = ImageDownloader.default
            downloader.downloadImage(with: url) { result in
                switch result {
                case .success(let value):
                    self.cache.store(value.image, forKey: md5Str)
                    success(value.image)
                case .failure(let error):
                    print("ImageDownloader下载图片失败：\(error)")
                }
            }
        }
    }
}
