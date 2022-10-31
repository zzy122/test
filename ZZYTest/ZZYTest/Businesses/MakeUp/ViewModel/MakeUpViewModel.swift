//
//  MakeUpViewModel.swift
//  ZZYTest
//
//  Created by my on 2022/10/27.
//

import Foundation
import RxFlow
import RxSwift
import RxCocoa

enum MakeUpList {
    case recommend
    case likes
    
    var title: String {
        switch self {
        case .likes: return "Likes"
        case .recommend: return "Recommended"
        }
    }
}

internal final class MakeUpViewModel: ViewModel {
    let steps: PublishRelay<Step> = PublishRelay()
    
    let dataSource: [MakeUpList] = [.recommend, .likes]
}
