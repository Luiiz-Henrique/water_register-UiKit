//
//  ViewController.swift
//  APP_UiKit_Acompanhamento-Hidrico
//
//  Created by Luiz Henrique da Silva Bezerra on 10/11/26.
//

import UIKit

final class ViewController: UIViewController {

    private let tabBarView = TabBarView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
    }

    private func setupViews() {
        // TabBarView is a UITabBarController, so it must be embedded as a child
        // view controller instead of being added directly as a subview.
        addChild(tabBarView)
        view.addSubview(tabBarView.view)
        tabBarView.didMove(toParent: self)
    }

    private func setupConstraints() {
        tabBarView.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tabBarView.view.topAnchor.constraint(equalTo: view.topAnchor),
            tabBarView.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tabBarView.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tabBarView.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }

}
