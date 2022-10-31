//
//  MakeUpSearchView.swift
//  ZZYTest
//
//  Created by my on 2022/10/31.
//

import UIKit
import SnapKit
import GeSwift

internal final class MakeUpSearchView: UIView {
    
    private lazy var contentView: UIView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.layer.borderColor = UIColor.ge.color(with: "#A3CFBF")?.cgColor
        $0.layer.borderWidth = 1.5
        $0.layer.cornerRadius = 15
        self.addSubview($0)
        $0.snp.makeConstraints { make in
            make.edges.equalTo(UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20))
        }
        return $0
    }(UIView())
    
    private lazy var searchIcon: UIImageView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.image = UIImage(named: "icon_makeup_search")
        self.contentView.addSubview($0)
        $0.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(20)
            make.width.height.equalTo(15)
        }
        return $0
    }(UIImageView())
    
    private lazy var placeholderLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.textColor = UIColor.ge.color(with: "#8B9BA2")
        $0.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        self.contentView.addSubview($0)
        $0.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(self.searchIcon.snp.right).offset(20)
        }
        return $0
    }(UILabel())
    
    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        placeholderLabel.text = "Search Dressing"
    }
}
