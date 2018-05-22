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
    var tip_new: Int = 0
    var default_add: Int = 0
    var web_url: String = ""
    var concern_id: String = ""
    var icon_url: String = ""
    var flags: Int = 0
    var type: Int = 0
    var name: String = "--"
    var category: String = "--"
}

