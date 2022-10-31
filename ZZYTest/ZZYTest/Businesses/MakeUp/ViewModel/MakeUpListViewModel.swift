//
//  MakeUpListViewModel.swift
//  ZZYTest
//
//  Created by my on 2022/10/31.
//

import Foundation
import RxCocoa
import RxFlow

struct MakeUpItem {
    let height: CGFloat
}

internal final class MakeUpListViewModel: ViewModel {
    var steps: PublishRelay<Step> = PublishRelay()
    
    let list: MakeUpList
    init(list: MakeUpList) {
        self.list = list
    }
    
    let dataSource: BehaviorRelay<[MakeUpItem]> = BehaviorRelay(value: [])
    
    func fetchData() {
        
        dataSource.accept((0 ..< 20).map({ _ in MakeUpItem(height: CGFloat(arc4random() % 200 + 150)) }))
    }
}
