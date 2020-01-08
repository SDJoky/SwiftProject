//
//  UILabel+Rx.swift
//  SwiftProject
//
//  Created by Joky_Lee on 2020/1/6.
//  Copyright © 2019 Joky_Lee. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

extension Reactive where Base : UILabel {
    var orEmpty:Observable<Bool> {
        return base.rx.observeWeakly(String.self, "text").map{ $0?.count == 0 }
    }
}
