//
//  CollectionReusableView.swift
//  AQWaterFall
//
//  Created by Joky on 2019/10/29.
//  Copyright © 2019 eyee. All rights reserved.
//

import UIKit

class CollectionReusableView: UICollectionReusableView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.green
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
