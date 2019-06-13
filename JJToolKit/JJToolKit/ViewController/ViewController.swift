//
//  ViewController.swift
//  JJToolKit
//
//  Created by YangJinjian on 2019/6/5.
//  Copyright © 2019 YangJinjian. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        let adPlaceholderView = UIView(frame: kScreenBounds)
//        adPlaceholderView.backgroundColor = .white
//        let introLabel = UILabel(frame: .zero)
//        introLabel.font = UIFont(name: "Verdana", size: 9.5)
//        introLabel.text = "Copyright © 2019 Qingdaonews.com All Rights Reserved."
//        introLabel.textColor = UIColor.colorWithHexString("#9E9E9E")
//        adPlaceholderView.addSubview(introLabel)
//        introLabel.snp.makeConstraints { (cons) in
//            cons.centerX.equalToSuperview()
//            cons.bottom.equalToSuperview().offset(-27)
//        }
//        let logo = UIImageView(image: UIImage(named: "flash_logo"))
//        adPlaceholderView.addSubview(logo)
//        if let _ = JJAdLauncher.shared.checkAdSchedulInfo() {
//            logo.snp.makeConstraints { (cons) in
//                cons.centerX.equalToSuperview()
//                cons.bottom.equalTo(introLabel.snp.top).offset(-8)
//            }
//        } else {
//            let centerY = kScreenHeight * 0.4 + logo.frame.size.height / 2
//            logo.snp.makeConstraints { (cons) in
//                cons.centerX.equalToSuperview()
//                cons.centerY.equalTo(centerY)
//            }
//        }
//        JJAdConfig.shared.placeholderView = adPlaceholderView
//        JJAdConfig.shared.adImageBottomSpace = 100
        
        let startTime: Double = 1560314000
        let endTime: Double = 1560597360
//        let model = JJAdModel(imageName: "test_mt4", startTime: startTime, endTime: endTime, canTouch: true, canSkip: true)
//        let imageUrl = "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1559733462821&di=5eb1b88b272c24c2bb0291364117502d&imgtype=0&src=http%3A%2F%2Fi3.bbs.fd.zol-img.com.cn%2Fg5%2FM00%2F0A%2F05%2FChMkJ1nAFqSITAdJAANLrfmw4mAAAgkMQNDmDUAA0vF899.jpg"
//        let model = JJAdModel(imageUrlStr: imageUrl, startTime: startTime, endTime: endTime, waitTime: 3)
//        JJAdLauncher.shared.launch(imageModel: model)
        let model = JJAdModel(videoName: "test_video", startTime: startTime, endTime: endTime)
        JJAdLauncher.shared.launch(imageModel: model)
    }

}

