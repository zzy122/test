//
//  AppService.swift
//  ZZYTest
//
//  Created by my on 2022/10/27.
//

import UIKit
import RxSwift
import RxCocoa
import RxFlow
import GeSwift

internal final class AppService {
    
    let window: UIWindow
    let coordinate = FlowCoordinator()
    init(window: UIWindow, options: [AnyHashable: Any]?) {
        self.window = window
        
        let appFlow = AppFlow()
        Flows.use(appFlow, when: .ready) { flowRoot in
            window.rootViewController = flowRoot
            window.makeKeyAndVisible()
        }
        
        coordinate.coordinate(flow: appFlow, with: AppStepper())
        
        customNavigationBar()
        if #available(iOS 13.0, *) {
            customNavigationBarAppearance()
        }
    }
    
    func customNavigationBar() {
        let appearance = UINavigationBar.appearance()
        appearance.titleTextAttributes = [.font: UIFont.systemFont(ofSize: 17, weight: .medium)]
        appearance.setBackgroundImage(UIImage.ge.image(withColor: .white, size: CGSize(width: 1, height: 1)), for: .default)
        appearance.shadowImage = nil
        appearance.isTranslucent = false
        appearance.tintColor = UIColor.ge.color(with: "333333")
    }
    
    @available(iOS 13.0, *)
    func customNavigationBarAppearance() {
        let appearence = UINavigationBarAppearance()
        appearence.titleTextAttributes = [.font: UIFont.systemFont(ofSize: 17, weight: .medium)]
        appearence.backgroundColor = UIColor.white
        appearence.shadowImage = nil
        appearence.shadowColor = UIColor.clear
        appearence.buttonAppearance.normal.titleTextAttributes = [
            .foregroundColor: UIColor.black,
            .font: UIFont.systemFont(ofSize: 17, weight: .regular)
        ]

        let navigationBar = UINavigationBar.appearance()
        navigationBar.isTranslucent = false
        navigationBar.tintColor = UIColor.ge.color(with: "333333")
        navigationBar.standardAppearance = appearence
        navigationBar.scrollEdgeAppearance = appearence
    }
}

struct AppStepper: Stepper {
    let steps: PublishRelay<Step> = PublishRelay()
    
    var initialStep: Step { AppStep.viewControllers }
}
