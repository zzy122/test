//
//  File.swift
//  ZZYTest
//
//  Created by my on 2022/10/27.
//

import UIKit
import GeSwift
import SnapKit

internal final class ViewControllersCell: UITableViewCell, Reusable {
    
    lazy var titleLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview($0)
        $0.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(15)
        }
        return $0
    }(UILabel())
    
    lazy var detailLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.textColor = UIColor.ge.color(with: "0x999999")
        $0.font = UIFont.systemFont(ofSize: 14)
        self.contentView.addSubview($0)
        $0.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalTo(-8)
        }
        return $0
    }(UILabel())
}
