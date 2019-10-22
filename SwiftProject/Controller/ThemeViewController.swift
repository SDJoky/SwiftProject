//
//  ThemeViewController.swift
//  SwiftProject
//
//  Created by Joky_Lee on 2019/8/1.
//  Copyright © 2019 Joky_Lee. All rights reserved.
//

import UIKit
import RxSwift
import RxDataSources
import MJRefresh
import SVProgressHUD
class ThemeViewController: UIViewController {

    private let dispose = DisposeBag()
    private let viewModel: ThemeVM = ThemeVM()
    private var tableView: UITableView! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.bindView()
        title = "MVVM + RxSwift + HandyJSON"
    }
    
    private let dataSource = RxTableViewSectionedReloadDataSource<ZHNewsModel>(configureCell: {ds,tv,ip,item in
        let cell : TestTableViewCell = tv.dequeueReusableCell(withIdentifier: "TestTableViewCell", for: ip) as! TestTableViewCell
        cell.desLbl.text = "标题: \(item.title)"
        cell.nameLbl.text = "描述:\(item.hint)"
        if item.images.count > 0 {
            cell.photoImgV.kf.setImage(with: URL(string: item.images[0]))
        }
        return cell
    })
    
    
}

extension ThemeViewController {
    fileprivate func setupUI() {
        view.backgroundColor = .red
        tableView = UITableView(frame: .zero, style: .plain)
        view.addSubview(tableView)
        tableView.register(UINib(nibName: "TestTableViewCell", bundle: nil), forCellReuseIdentifier: "TestTableViewCell")
        tableView.rowHeight = TestTableViewCell.cellHeigh()
        tableView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(view)
            make.top.equalTo(view.snp.top).offset(0);
        }
        tableView.tableHeaderView = UIView()
    }
    
//    数据绑定操作
    fileprivate func bindView() {
        // 设置代理
        tableView.rx.setDelegate(self).disposed(by: dispose)
        viewModel.data
            .asObservable()
            .bind(to: self.tableView.rx.items(dataSource: dataSource))
            .disposed(by: dispose)
        
//        下拉刷新
        tableView.mj_header = MJRefreshGifHeader()
        tableView.mj_header
            .rx
            .refreshing
            .subscribe({ [weak self](e) in
            self?.viewModel.loadData(endFreshBinder: self!.tableView.rx.endRefresh, disposeBag: self!.dispose)

        }).disposed(by: self.dispose)
        
//        上拉加载
        tableView.mj_footer = MJRefreshAutoGifFooter()
        tableView.mj_footer
            .rx
            .refreshing
            .subscribe({ [weak self](e) in
            self?.viewModel.loadMoreData(endFreshBinder: self!.tableView.rx.endRefresh, disposeBag: self!.dispose)
        }).disposed(by: self.dispose)
        
//        选中某行
        tableView.rx
            .modelSelected(StoryModel.self)
            .subscribe(onNext: { (model) in
                SVProgressHUD.showInfo(withStatus: model.hint)
            }).disposed(by: dispose)
        
        tableView.mj_header.beginRefreshing()

    }
    
}

extension ThemeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 200
    }
}

