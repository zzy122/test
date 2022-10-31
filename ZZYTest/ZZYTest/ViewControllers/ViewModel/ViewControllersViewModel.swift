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
    case chatList
    
    var title: String {
        switch self {
        case .makeUp: return "Make Up"
        case .chatList: return "chatList"
        }
    }
    
    var detail: String {
        switch self {
        case .makeUp: return "MakeUpViewController"
        case .chatList:
            return "test"
        }
    }
    
    var step: AppStep {
        switch self {
        case .makeUp: return .makeUp
        case .chatList: return .chatList
        }
    }
}

internal final class ViewControllersViewModel: Stepper {
    let steps: PublishRelay<Step> = PublishRelay()
    let dataSource: BehaviorRelay<[ViewController]> = BehaviorRelay(value: [.makeUp, .chatList])
}
