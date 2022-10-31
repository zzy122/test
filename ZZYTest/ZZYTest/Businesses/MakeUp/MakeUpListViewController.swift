//
//  MakeUpListViewController.swift
//  ZZYTest
//
//  Created by my on 2022/10/31.
//

import UIKit
import SnapKit
import RxCocoa
import RxSwift
import GeSwift

import protocol JXSegmentedView.JXSegmentedListContainerViewListDelegate

internal final class MakeUpListViewController: BaseViewController, ViewModelBased {
    
    var viewModel: MakeUpListViewModel!
    
    private lazy var collectionView: UICollectionView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.ge.register(reusableNibCell: MakeUpListCell.self)
        self.view.addSubview($0)
        $0.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        return $0
    }(UICollectionView(frame: .zero, collectionViewLayout: {
        $0.lineSpacing = 20.0
        $0.interitemSpacing = 0
        $0.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 20, right: 10)
        $0.scrollDirection = .vertical
        $0.numberOfColumns = 2
        $0.delegate = self
        return $0
    }(GXWaterfallViewLayout())))
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.dataSource.bind(to: collectionView.rx.items(cellIdentifier: MakeUpListCell.reuseIdentifier, cellType: MakeUpListCell.self))({ collectionView, item, cell in
            /// TODO
        }).disposed(by: disposeBag)
        
        viewModel.fetchData()
    }
}

extension MakeUpListViewController: GXWaterfallViewLayoutDelegate {
    func size(layout: GXWaterfallViewLayout, indexPath: IndexPath, itemSize: CGFloat) -> CGFloat {
        viewModel.dataSource.value[indexPath.item].height
    }
}

extension MakeUpListViewController: JXSegmentedListContainerViewListDelegate {
    func listView() -> UIView {
        view
    }
}
