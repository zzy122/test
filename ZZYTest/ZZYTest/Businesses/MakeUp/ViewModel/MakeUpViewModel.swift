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

internal final class MakeUpViewModel: ViewModel {
    let steps: PublishRelay<Step> = PublishRelay()
}
