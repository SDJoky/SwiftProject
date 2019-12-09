//
//  CollectionViewCell.swift
//  AQWaterFall
//
//  Created by Joky on 2019/10/29.
//  Copyright © 2019 eyee. All rights reserved.
//

import UIKit

class FlowCollectionViewCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.backgroundColor = UIColor.orange
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
