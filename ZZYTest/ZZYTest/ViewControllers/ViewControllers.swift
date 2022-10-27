//
//  ViewControllers.swift
//  ZZYTest
//
//  Created by my on 2022/10/27.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import RxDataSources
import GeSwift

internal final class ViewControllers: UIViewController {
    
    var viewModel: ViewControllersViewModel!
    
    private lazy var tableView: UITableView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.contentInsetAdjustmentBehavior = .never
        $0.rowHeight = 44
        $0.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        $0.ge.register(reusableCell: ViewControllersCell.self)
        self.view.addSubview($0)
        $0.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        return $0
    }(UITableView(frame: .zero, style: .grouped))
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "HOME"
        
        viewModel.dataSource.bind(to: tableView.rx.items(cellIdentifier: ViewControllersCell.reuseIdentifier, cellType: ViewControllersCell.self))({ tableView, item, cell in
            cell.titleLabel.text = item.title
            cell.detailLabel.text = item.detail
            cell.accessoryType = .disclosureIndicator
        }).disposed(by: disposeBag)
        
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
        
        tableView.rx.modelSelected(ViewController.self).map({ $0.step }).bind(to: viewModel.steps).disposed(by: disposeBag)
    }
}

extension ViewControllers: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
