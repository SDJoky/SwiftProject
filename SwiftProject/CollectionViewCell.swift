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
            titleLbl.text = homeNewsModel.name
            categoryLbl.text = homeNewsModel.category
        }
    }
    
    @IBOutlet weak var categoryLbl: UILabel!
    @IBOutlet weak var titleLbl: UILabel!
    
}
