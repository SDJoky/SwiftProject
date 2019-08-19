//
//  Test1DetailViewController.swift
//  SwiftProject
//
//  Created by Joky_Lee on 2018/9/13.
//  Copyright © 2018年 Joky_Lee. All rights reserved.
//

import UIKit

class Test1DetailViewController: UIViewController {
   
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .yellow
        let btn : UIButton = creatBtn(title: "点击diss", titleColor: UIColor.red, backGroundColor: UIColor.yellow)
        btn.addTarget(self, action: #selector(disAction), for: .touchUpInside)
        self.view.addSubview(btn)
        btn.snp.remakeConstraints { (make) in
            make.centerX.equalTo(self.view)
            make.centerY.equalTo(self.view)
            make.width.equalTo(100)
            make.height.equalTo(30)
        }
    }

    func creatBtn(title:String,titleColor:UIColor,backGroundColor:UIColor) -> UIButton {
        let btn = UIButton()
        btn.setTitle(title, for:.normal)
        btn.setTitleColor(titleColor, for: .normal)
        btn.backgroundColor = backGroundColor
        return btn
    }
    
    @objc func disAction()
    {
        if (self.navigationController != nil) {
            self.navigationController?.popViewController(animated: true)
        }else
        {
            self.dismiss(animated: true, completion: nil)
        }
    }

}
