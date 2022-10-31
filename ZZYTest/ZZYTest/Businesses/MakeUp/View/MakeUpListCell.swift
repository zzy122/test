//
//  MakeUpListCell.swift
//  ZZYTest
//
//  Created by my on 2022/10/31.
//

import UIKit
import GeSwift

internal final class MakeUpListCell: UICollectionViewCell, NibReusable {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var image: UIImageView! {
        didSet {
            image.layer.cornerRadius = 24
            image.clipsToBounds = true
        }
    }
    @IBOutlet weak var avatar: UIImageView! {
        didSet {
            avatar.layer.cornerRadius = 7
            avatar.clipsToBounds = true
        }
    }
    @IBOutlet weak var pictureNumberLabel: UILabel!
    @IBOutlet weak var pictureContainerView: UIView! {
        didSet {
            pictureContainerView.layer.cornerRadius = 7
            pictureContainerView.clipsToBounds = true
        }
    }
    @IBOutlet weak var collectButton: UIButton! {
        didSet {
            collectButton.layer.cornerRadius = 16
            collectButton.clipsToBounds = true
        }
    }
    
    @IBAction func touchCollectButton(_ sender: UIButton) {
        ///
        sender.isSelected.toggle()
    }
}

