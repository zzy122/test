//
//  MakeUpViewController.swift
//  ZZYTest
//
//  Created by my on 2022/10/27.
//

import UIKit
import GeSwift
import RxSwift
import RxCocoa
import JXSegmentedView
import SnapKit

extension MakeUpList {
    var controller: JXSegmentedListContainerViewListDelegate {
        MakeUpListViewController.instantiate(withViewModel: MakeUpListViewModel(list: self))
    }
}

internal final class MakeUpViewController: BaseViewController, ViewModelBased {
    
    var viewModel: MakeUpViewModel!
    
    private lazy var searchView: MakeUpSearchView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview($0)
        $0.snp.makeConstraints { make in
            make.top.left.right.equalTo(0)
            make.height.equalTo(62)
        }
        return $0
    }(MakeUpSearchView())
    
    private lazy var segmentedViewDataSource: JXSegmentedTitleDataSource = {
        $0.titleNormalFont = UIFont.systemFont(ofSize: 16, weight: .semibold)
        $0.titleSelectedFont = UIFont.systemFont(ofSize: 17, weight: .semibold)
        $0.titleNormalColor = UIColor.ge.color(with: "999999")!
        $0.titleSelectedColor = UIColor.ge.color(with: "#100D2C")!
        $0.isItemSpacingAverageEnabled = false
        return $0
    }(JXSegmentedTitleDataSource())
    
    private lazy var segmentedView: JXSegmentedView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.dataSource = segmentedViewDataSource
        let lineView = JXSegmentedIndicatorLineView()
        lineView.indicatorColor = UIColor.ge.color(with: "#6E60EE")!
        lineView.indicatorWidth = 16
        lineView.indicatorHeight = 4
        lineView.indicatorCornerRadius = 2
        $0.indicators = [lineView]
        self.view.addSubview($0)
        $0.snp.makeConstraints { make in
            make.top.equalTo(self.searchView.snp.bottom).offset(0)
            make.left.right.equalTo(0)
            make.height.equalTo(44)
        }
        return $0
    }(JXSegmentedView(frame: .zero))
    
    private lazy var listContainerView: JXSegmentedListContainerView! = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        self.segmentedView.listContainer = $0
        self.view.addSubview($0)
        $0.snp.makeConstraints { make in
            make.top.equalTo(self.segmentedView.snp.bottom).offset(0)
            make.left.right.bottom.equalTo(0)
        }
        return $0
    }(JXSegmentedListContainerView(dataSource: self.dataSource))

    private let dataSource = SegmentedListContainerViewDataSource()
    
    private let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Make Up"
        
        Observable.just(viewModel.dataSource.map({ $0.title })).bind(to: segmentedViewDataSource.rx.titles).disposed(by: disposeBag)
        Observable.just(viewModel.dataSource.map { $0.controller }).bind(to: listContainerView.rx.dataSource).disposed(by: disposeBag)
    }
}
