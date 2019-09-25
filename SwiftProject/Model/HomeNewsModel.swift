//
//  HomeNewsModel.swift
//  SwiftProject
//
//  Created by Joky_Lee on 2018/5/22.
//  Copyright © 2018年 Joky_Lee. All rights reserved.
//

import UIKit
import HandyJSON

struct  HomeNewsModel: HandyJSON {
    var type: Int = 0
    var image: String = ""
    var hint: String = ""
    var title: String = ""
    var id: Int = 0
    var image_hue: String = ""
    var url: String = ""
}

