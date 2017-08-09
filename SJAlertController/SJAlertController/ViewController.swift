//
//  ViewController.swift
//  SJAlertController
//
//  Created by 江奔 on 2017/8/9.
//  Copyright © 2017年 TCGroup. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func showClick(_ sender: UIButton) {
        
        SJAlertController().showAlert("提示", subTitle: "Hello, My name is SteveJones", buttonTitle: "取消", otherButtonTitle:"确定") { (btn) in
            print("按了确定")
        }
        
    }


}

