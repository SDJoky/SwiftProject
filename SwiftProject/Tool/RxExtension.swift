//
//  MJRefreshExtension.swift
//  SwiftProject
//
//  Created by Joky_Lee on 2019/10/22.
//  Copyright © 2019 Joky_Lee. All rights reserved.
//

import Foundation

extension Reactive where Base : MJRefreshComponent {
    public var refreshing:ControlEvent<Void> {
        let source: Observable<Void> = Observable.create {
            [weak control = self.base] observer in
            if let control = control {
                control.refreshingBlock = {
                    observer.on(.next(()))
                }
            }
            return Disposables.create()
        }
        return ControlEvent(events: source)
    }
    
    public var endRefreshing: Binder<Bool> {
        return Binder(base) {
            refresh, isEnd in
            if isEnd {
                refresh.endRefreshing()
            }
        }
    }
}

extension Reactive where Base:UIScrollView {
    
    public var endRefresh:Binder<Bool> {
        let source = Binder<Bool>(self.base,scheduler: MainScheduler.instance) { (base,end) in
            if base.mj_header.isRefreshing {
                base.mj_header.endRefreshing()
            }
            if base.mj_footer.isRefreshing {
                base.mj_footer.endRefreshing()
            }
        }
        return source
    }
    
    
}

