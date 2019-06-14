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
    
    func findAdVideo(withName name: String, fileType type: String,
                     success: @escaping(String)->(), failure: @escaping()->()) {
        let filePath = videoCachePath + "/\(name).\(type)"
        if kFM.fileExists(atPath: filePath) {
            // 找到文件
            success(filePath)
        } else {
            // 未找到文件
            failure()
        }
    }
    
    func store(image: UIImage, forKey key: String) {
        imageCache.store(image, forKey: key)
    }
    
    func deleteCache(withKey key: String) {
        if key.contains(".") {
            // 视频文件名
            let filePath = videoCachePath + "/\(key)"
            do {
                try kFM.removeItem(atPath: filePath)
            } catch let error {
                print("JJAdCache删除文件失败:\(error.localizedDescription)\n文件路径:\(filePath)")
            }
            return
        }
        // 图片缓存
        imageCache.removeImage(forKey: key)
    }
    
    func clean() {
        kUD.removeObject(forKey: JJAdUserDefaultKey.kAdSchedulInfo)
        kUD.synchronize()
        imageCache.clearMemoryCache()
        imageCache.clearDiskCache()
        try! kFM.removeItem(atPath: videoCachePath)
    }
    
    func storeVideoFile(name: String, type: String) {
        // 如果文件夹不存在，先创建文件夹
        if !FileManager.directoryIsExists(path: videoCachePath) {
            do {
                //withIntermediateDirectories为ture表示路径中间如果有不存在的文件夹都会创建
                try kFM.createDirectory(atPath: videoCachePath, withIntermediateDirectories: true, attributes: nil)
            } catch let error {
                print("JJAdCache创建Cache文件夹出错:\(error.localizedDescription)")
                return
            }
        }
        let filePath = videoCachePath + "/\(name).\(type)"
        if let videoPath = kBundle.path(forResource: name, ofType: type) {
            do {
                try kFM.copyItem(atPath: videoPath, toPath: filePath)
            } catch let error {
                print("JJAdCache复制文件时出错:\(error.localizedDescription)")
            }
        }
    }
}
