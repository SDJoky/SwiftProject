//
//  ZHNewsModel.swift
//  SwiftProject
//
//  Created by Joky_Lee on 2019/10/22.
//  Copyright © 2019 Joky_Lee. All rights reserved.
//

import Foundation
import HandyJSON
import RxDataSources
struct StoryModel: HandyJSON {
    var id: Int = 0
    var image: String = ""
    var title: String = ""
    var url: String = ""
    var ga_prefix: String = ""
    var hint: String = ""
    var type: Int = 0
    var images: [String] = [""]
}

struct ZHNewsModel{
    var date: String = ""
    var stories: [StoryModel] = []
    var items: [Item] = []
}

extension ZHNewsModel : HandyJSON,SectionModelType {
    init(original: ZHNewsModel, items: [StoryModel]) {
        self = original
        self.items = items
    }
    
    typealias Item = StoryModel
    var identity: String {
        return date
    }
    
}
