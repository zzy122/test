//
//  MakeUpViewController.swift
//  ZZYTest
//
//  Created by my on 2022/10/27.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import GeSwift

internal final class MakeUpViewController: BaseViewController, ViewModelBased {
    
    var viewModel: MakeUpViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Make Up"
    }
}
