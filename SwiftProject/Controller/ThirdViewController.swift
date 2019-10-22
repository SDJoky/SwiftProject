//
//  ThirdViewController.swift
//  SwiftProject
//
//  Created by Joky_Lee on 2018/9/14.
//  Copyright © 2018年 Joky_Lee. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import NSObject_Rx
import RxDataSources
import SnapKit
import Moya
import Kingfisher
import MJRefresh
import SVProgressHUD

class ThirdViewController: UIViewController {

    private lazy var viewModel : TableVM = TableVM()
    private let tableView = UITableView()
    
    private let dataSource = RxTableViewSectionedReloadDataSource<DataSection>(configureCell: {ds,tv,ip,item in
        let cell : TestTableViewCell = tv.dequeueReusableCell(withIdentifier: "TestTableViewCell", for: ip) as! TestTableViewCell
        cell.desLbl.text = "time: \(item.publishedAt)"
        cell.photoImgV.kf.setImage(with: URL(string: item.url))
        cell.nameLbl.text = "name:\(item.who)"
        return cell
    })
    
    var outPut : TableVM.DataOutput?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindView()
        // 加载数据
        tableView.mj_header.beginRefreshing()
    }
    
    private lazy var headerV : SDTestHeaderView = {
        let headerV = SDTestHeaderView()
        headerV.frame = CGRect(x: 0, y: 0, width: SCREENW, height: 200)
        headerV.iconBtn.addTarget(self, action: #selector(iconClick), for: .touchUpInside)
        return headerV
    }()
    
    @objc func iconClick() {
        print("点击 icon")
        SVProgressHUD.showSuccess(withStatus: "点击icon")
    }
}

extension ThirdViewController {
    fileprivate func setupUI() {
        view.addSubview(tableView)
        tableView.register(UINib(nibName: "TestTableViewCell", bundle: nil), forCellReuseIdentifier: "TestTableViewCell")
        tableView.rowHeight = TestTableViewCell.cellHeigh()
        tableView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(view)
            make.top.equalTo(view.snp.top).offset(0);
        }
        tableView.tableHeaderView = headerV
    }
    
    fileprivate func bindView() {
        
        // 设置代理
        tableView.rx.setDelegate(self).disposed(by: rx.disposeBag)
        let vmInput = TableVM.DataInput(category: .welfare)
        let vmOutput = viewModel.transform(input: vmInput)
        
        vmOutput.sections.asDriver().drive(tableView.rx.items(dataSource: dataSource)).disposed(by: rx.disposeBag)
        
        vmOutput.refreshStaus.asObservable().subscribe(onNext: {[weak self] status in
            switch status {
            case .beingHeaderRefresh:
                self!.tableView.mj_header.beginRefreshing()
            case .endHeaderRefresh:
                self!.tableView.mj_header.endRefreshing()
            case .beingFooterRefresh:
                self!.tableView.mj_footer.beginRefreshing()
            case .endFooterRefresh:
                self!.tableView.mj_footer.endRefreshing()
            case .noMoreData:
                self!.tableView.mj_footer.endRefreshingWithNoMoreData()
            default:
                break
            }
        }).disposed(by: rx.disposeBag)
        
        tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            vmOutput.requestCommand.onNext(true)
        })
        tableView.mj_footer = MJRefreshAutoNormalFooter(refreshingBlock: {
            vmOutput.requestCommand.onNext(false)
        })
    }
    
}

extension ThirdViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let detailVC = ThemeViewController()
        detailVC.hidesBottomBarWhenPushed = true;
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 170
    }
}
