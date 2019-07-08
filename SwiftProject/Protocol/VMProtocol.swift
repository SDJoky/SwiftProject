//
//  VMProtocol.swift
//  SwiftProject
//
//  Created by Joky_Lee on 2019/7/8.
//  Copyright © 2019 Joky_Lee. All rights reserved.
//

import Foundation

protocol VMProtocol {
//    通过 associatedtype 关键字来指定关联类型
    associatedtype Input
    associatedtype Output
    func transform(input : Input) -> Output
}
