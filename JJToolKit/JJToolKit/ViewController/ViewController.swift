//
//  ViewController.swift
//  JJToolKit
//
//  Created by YangJinjian on 2019/6/5.
//  Copyright © 2019 YangJinjian. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let adPlaceholderView = UIView(frame: kScreenBounds)
        adPlaceholderView.backgroundColor = .white
        let intro = UIImageView(image: UIImage(named: "intro"))
        adPlaceholderView.addSubview(intro)
        intro.snp.makeConstraints { (cons) in
            cons.centerX.equalToSuperview()
            cons.bottom.equalToSuperview().offset(-25)
        }
        let logo = UIImageView(image: UIImage(named: "logo"))
        adPlaceholderView.addSubview(logo)
        if let _ = JJAdLauncher.shared.checkAdSchedulInfo() {
            print("此时应该显示广告")
            logo.snp.makeConstraints { (cons) in
                cons.centerX.equalToSuperview()
                cons.bottom.equalTo(intro.snp.top).offset(-5)
            }
        } else {
            print("没有缓存图片")
            logo.snp.makeConstraints { (cons) in
                cons.centerX.equalToSuperview()
                cons.centerY.equalToSuperview().offset(-30)
            }
        }
        JJAdConfig.shared.placeholderView = adPlaceholderView
        JJAdConfig.shared.adImageBottomSpace = 100
//        let startTime: Double = 1560247360
//        let endTime: Double = 1560447360
//        let model = JJAdModel(imageName: "test_mt", startTime: startTime, endTime: endTime, canTouch: true, canSkip: true)
//        let imageUrl = "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1559733462821&di=5eb1b88b272c24c2bb0291364117502d&imgtype=0&src=http%3A%2F%2Fi3.bbs.fd.zol-img.com.cn%2Fg5%2FM00%2F0A%2F05%2FChMkJ1nAFqSITAdJAANLrfmw4mAAAgkMQNDmDUAA0vF899.jpg"
//        let model = JJAdModel(imageUrlStr: imageUrl, startTime: startTime, endTime: endTime, waitTime: 3)
//        JJAdLauncher.shared.launch(imageModel: model)
    }

}

