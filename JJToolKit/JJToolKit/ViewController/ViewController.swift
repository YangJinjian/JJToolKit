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
//        if let image = UIImage(named: "test_mt") {
//            JJAdLauncher.shared.launch(adImage: image, waitTime: 3, canSkip: true, canTouch: true)
//        }
        let imageUrl = "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1559733462821&di=5eb1b88b272c24c2bb0291364117502d&imgtype=0&src=http%3A%2F%2Fi3.bbs.fd.zol-img.com.cn%2Fg5%2FM00%2F0A%2F05%2FChMkJ1nAFqSITAdJAANLrfmw4mAAAgkMQNDmDUAA0vF899.jpg"
        JJAdLauncher.shared.launch(webImage: imageUrl, waitTime: 3,
                                   canSkip: true, canTouch: true, showType: .showWhenCached)
    }

}

