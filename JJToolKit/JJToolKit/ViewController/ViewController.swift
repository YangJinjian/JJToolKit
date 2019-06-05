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
        if let image = UIImage(named: "test_mt") {
            let ad = JJAdLauncher.shared.launch(adImage: image, waitTime: 3, canSkip: true, canTouch: true)
            JJAdLauncher.shared.show(ad: ad)
        }
    }


}

