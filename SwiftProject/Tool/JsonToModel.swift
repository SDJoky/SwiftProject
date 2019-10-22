//
//  JsonToModel.swift
//  SwiftProject
//
//  Created by Joky_Lee on 2019/10/22.
//  Copyright © 2019 Joky_Lee. All rights reserved.
//

import Moya
import HandyJSON
import RxSwift

//扩展Moya支持HandyJSON的解析
extension ObservableType where E == Response {
    public func mapModel<T: HandyJSON>(_ type: T.Type) -> Observable<T> {
        return flatMap { response -> Observable<T> in
            return Observable.just(try response.mapModel(T.self))
        }
    }
}

extension Response {
    func mapModel<T: HandyJSON>(_ type: T.Type) throws -> T {
        let jsonString = String.init(data: data, encoding: .utf8)
        if let modelT = JSONDeserializer<T>.deserializeFrom(json: jsonString) {
            return modelT
        }
        return JSONDeserializer<T>.deserializeFrom(json: "{\"msg\":\"请求有误\"}")!
    }
}
