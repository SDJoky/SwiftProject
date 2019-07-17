//
//  SDTestHeaderView.swift
//  SwiftProject
//
//  Created by Joky_Lee on 2019/7/17.
//  Copyright © 2019 Joky_Lee. All rights reserved.
//

import UIKit

class SDTestHeaderView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupInterface()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupInterface() {
        self.backgroundColor = .yellow
        addSubview(bgImageV)
        addSubview(messageBtn)
        addSubview(iconBtn)
        
        bgImageV.snp.makeConstraints { (make) in
            make.left.bottom.right.equalTo(self)
            make.top.equalTo(0)
        }
        
        messageBtn.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize(width: 44, height: 44))
            make.right.equalTo(self)
            make.top.equalTo(0)
        }
        
        iconBtn.snp.makeConstraints { (make) in
            make.centerX.equalTo(SCREENW * 0.5)
            make.size.equalTo(CGSize(width: 75, height: 75))
            make.centerY.equalTo(self)
        }
    }
    
    lazy var bgImageV : UIImageView =  {
        let bgImageV = UIImageView()
        bgImageV.contentMode = .scaleToFill
        bgImageV.image = UIImage(named: "Me_ProfileBackground")
        return bgImageV
    }()

    lazy var messageBtn : UIButton = {
        let messageBtn = UIButton()
        messageBtn.setImage(UIImage(named: "Me_message_20x20_"), for: .normal)
        return messageBtn
    }()
    
    lazy var iconBtn : UIButton = {
        let iconBtn = UIButton()
        iconBtn.setBackgroundImage(UIImage(named: "Me_AvatarPlaceholder_75x75_"), for: .normal)
        iconBtn.layer.cornerRadius = iconBtn.frame.size.width * 0.5
        iconBtn.layer.masksToBounds = true
        return iconBtn
    }()
}
