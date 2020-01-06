//
//  UITextField+Rx.swift
//  DoNewSeas
//
//  Created by Joky_Lee on 2020/1/6.
//  Copyright © 2019 Joky_Lee. All rights reserved.
//

import RxSwift
import RxCocoa

extension Reactive where Base : UITextField {
    var tap:ControlEvent<()> {
        let source = controlEvent(.editingDidBegin).map{ [weak control = self.base] in
            control?.resignFirstResponder()
        }.flatMapLatest{_ in
            return Observable<()>.just(())
        }.takeUntil(deallocated)
        return ControlEvent(events: source)
    }
}
