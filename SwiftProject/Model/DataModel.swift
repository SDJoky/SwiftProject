//
//  DataModel.swift
//  SwiftProject
//
//  Created by Joky_Lee on 2019/7/8.
//  Copyright © 2019 Joky_Lee. All rights reserved.
//

import UIKit
import ObjectMapper
import RxDataSources

struct DataModel: Mappable {
    var _id         = ""
    var createdAt   = ""
    var desc        = ""
    var publishedAt = ""
    var source      = ""
    var type        = ""
    var url         = ""
    var used        = ""
    var who         = ""
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        _id         <- map["_id"]
        createdAt   <- map["createdAt"]
        desc        <- map["desc"]
        publishedAt <- map["publishedAt"]
        source      <- map["source"]
        type        <- map["type"]
        url         <- map["url"]
        used        <- map["used"]
        who         <- map["who"]
    }
    
}

struct DataSection {
    var items : [Item]
    
}

extension DataSection : SectionModelType {
    typealias Item = DataModel
    init(original: DataSection, items: [DataSection.Item]) {
        self = original
        self.items = items
    }
}
