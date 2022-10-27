//
//  ViewControllersViewModel.swift
//  ZZYTest
//
//  Created by my on 2022/10/27.
//

import Foundation
import RxSwift
import RxCocoa
import RxFlow

enum ViewController {
    case makeUp
    
    var title: String {
        switch self {
        case .makeUp: return "Make Up"
        }
    }
    
    var detail: String {
        switch self {
        case .makeUp: return "MakeUpViewController"
        }
    }
    
    var step: AppStep {
        switch self {
        case .makeUp: return .makeUp
        }
    }
}

internal final class ViewControllersViewModel: Stepper {
    let steps: PublishRelay<Step> = PublishRelay()
    
    let dataSource: BehaviorRelay<[ViewController]> = BehaviorRelay(value: [.makeUp])
}
