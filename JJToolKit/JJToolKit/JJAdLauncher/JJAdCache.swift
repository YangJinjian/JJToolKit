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
    private let imageCache = ImageCache(name: "JJAdImageCache")
    private let videoCachePath = "\(cacheDir)/JJAdLauncher/VideoCache"
    // 防止外部使用init方法初始化
    private override init() {}
    
    func findAdImage(withKey key: String, success: @escaping(UIImage)->(), failure: @escaping()->()) {
        if imageCache.isCached(forKey: key) {
            imageCache.retrieveImage(forKey: key) { result in
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
                    self.imageCache.store(value.image, forKey: md5Str)
                    success(value.image)
                case .failure(let error):
                    print("ImageDownloader下载图片失败：\(error)")
                }
            }
        }
    }
    
    func findAdVideo(withName name: String, success: @escaping(String)->(), failure: @escaping()->()) {
        if FileManager.directoryIsExists(path: videoCachePath) {
            let key = name.md5()
            let filePath = videoCachePath + "/\(key)"
            if kFM.fileExists(atPath: filePath) {
                // 找到文件
                success(filePath)
            } else {
                // 未找到文件，尝试根据文件名从Bundle中查找，如果找到文件，则复制到Cache文件夹中
                if let videoPath = kBundle.path(forResource: name, ofType: "mp4") {
                    do {
                        try kFM.copyItem(atPath: videoPath, toPath: filePath)
                    } catch let error {
                        print("JJAdCache复制文件时出错:\(error.localizedDescription)")
                    }
                }
                failure()
            }
        } else {
            print("JJAdCache没有视频缓存文件夹，创建Cache文件夹")
            //withIntermediateDirectories为ture表示路径中间如果有不存在的文件夹都会创建
            do {
                try kFM.createDirectory(atPath: videoCachePath, withIntermediateDirectories: true, attributes: nil)
            } catch let error {
                print("JJAdCache创建Cache文件夹出错:\(error.localizedDescription)")
            }
            failure()
        }
    }
    
    func store(image: UIImage, forKey key: String) {
        imageCache.store(image, forKey: key)
    }
    
    func deleteCache(withKey key: String) {
        imageCache.removeImage(forKey: key)
    }
    
    func clean() {
        kUD.removeObject(forKey: JJAdUserDefaultKey.kAdSchedulInfo)
        kUD.synchronize()
        imageCache.clearMemoryCache()
        imageCache.clearDiskCache()
    }
}
