//
//  NavBarAppearance+Ext.swift
//  DemoApp
//
//  Created by Alex Kovalov on 10/30/24.
//

import UIKit

enum UINavigationBarAppearanceType {
    case defaultAppear
    case opaque
    case transparent
}

extension UINavigationBarAppearance {
    func customNavBarAppearance(
        _ type: UINavigationBarAppearanceType,
        titleColor: UIColor = .black,
        largeTitleColor: UIColor = .black,
        buttonColor: UIColor = .black
    ) {
        let customNavBarAppearance = UINavigationBarAppearance()

        switch type {
        case .defaultAppear:
            customNavBarAppearance.configureWithDefaultBackground()
            customNavBarAppearance.backgroundColor = .white
        case .opaque:
            customNavBarAppearance.configureWithOpaqueBackground()
            customNavBarAppearance.backgroundColor = .white
            customNavBarAppearance.shadowColor = .clear
        case .transparent:
            customNavBarAppearance.configureWithTransparentBackground()
        }

        customNavBarAppearance.titleTextAttributes = [
            .foregroundColor: titleColor,
            .font: UIFont.systemFont(ofSize: 17, weight: .semibold)
        ]
        customNavBarAppearance.largeTitleTextAttributes = [
            .foregroundColor: largeTitleColor,
            .font: UIFont.systemFont(ofSize: 24, weight: .semibold)
        ]


        let backImage = UIImage.backButtonIcon.withTintColor(.app1E2228, renderingMode: .alwaysOriginal)

        customNavBarAppearance.setBackIndicatorImage(backImage, transitionMaskImage: backImage)
        customNavBarAppearance.backButtonAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.clear]

        UINavigationBar.appearance().scrollEdgeAppearance = customNavBarAppearance
        UINavigationBar.appearance().compactAppearance = customNavBarAppearance
        UINavigationBar.appearance().standardAppearance = customNavBarAppearance

        if #available(iOS 15.0, *) {
            UINavigationBar.appearance().compactScrollEdgeAppearance = customNavBarAppearance
        }
    }
}
