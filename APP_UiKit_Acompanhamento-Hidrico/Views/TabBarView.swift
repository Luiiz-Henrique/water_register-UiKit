//
//  TabBarView.swift
//  APP_UiKit_Acompanhamento-Hidrico
//
//  Created by Luiz Henrique da Silva Bezerra on 16/11/26.
//

import UIKit

final class TabBarView: UITabBarController {

    let tab1VC = WaterTrackerViewController()
    let tab2VC = HistoryViewController()

    override func viewDidLoad() {
        super.viewDidLoad()

        tab1VC.tabBarItem = UITabBarItem(
            title: "Registros",
            image: UIImage(systemName: "waterbottle"),
            selectedImage: nil
        )

        tab2VC.tabBarItem = UITabBarItem(
            title: "Histórico",
            image: UIImage(systemName: "clock.arrow.trianglehead.counterclockwise.rotate.90"),
            selectedImage: nil
        )
    

        viewControllers = [
            tab1VC,
            tab2VC,
        ]

        delegate = self
    }

}

extension TabBarView: UITabBarControllerDelegate {
    
    func tabBarController(
        _ tabBarController: UITabBarController,
        didSelect viewController: UIViewController
    ) {
        print(tabBarController.selectedIndex)
    }
    
}
    

