//
//  ViewController.swift
//  CustomSegmentControlDemo
//
//  Created by   admin on 31.07.2020.
//  Copyright © 2020 Evgeny Ezub. All rights reserved.
//

import UIKit

/// the use of SnapKit helps to use contstraint in easy way
import SnapKit

class ViewController: UIViewController {

    let customSegmentControl = CustomSegmentControl(withSelected: 0)
    
    override func viewDidLoad() {
        super.viewDidLoad()                
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.view.addSubview(customSegmentControl)
        customSegmentControl.snp.makeConstraints { (make) in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(100)
        }
    }

}

