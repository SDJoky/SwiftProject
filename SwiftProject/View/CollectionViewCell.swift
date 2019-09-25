//
//  CollectionViewCell.swift
//  SwiftProject
//
//  Created by Joky_Lee on 2018/5/22.
//  Copyright © 2018年 Joky_Lee. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    var homeNewsModel = HomeNewsModel() {
        didSet{
            titleLbl.text = homeNewsModel.title
            categoryLbl.text = homeNewsModel.hint
            imageV.kf.setImage(with: URL(string: homeNewsModel.image))

        }
    }
    @IBOutlet weak var categoryLbl: UILabel!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var imageV: UIImageView!
    
}
