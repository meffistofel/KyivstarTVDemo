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
        titleColor: UIColor = UIColor(.black),
        largeTitleColor: UIColor = UIColor(.black),
        buttonColor: UIColor = UIColor(.black)
    ) {
        let customNavBarAppearance = UINavigationBarAppearance()

        switch type {
        case .defaultAppear:
            customNavBarAppearance.configureWithDefaultBackground()
            customNavBarAppearance.backgroundColor = UIColor(.white)
        case .opaque:
            customNavBarAppearance.configureWithOpaqueBackground()
            customNavBarAppearance.backgroundColor = UIColor(.white)
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

        let barButtonItemAppearance = UIBarButtonItemAppearance(style: .plain)
        barButtonItemAppearance.normal.titleTextAttributes = [.foregroundColor: buttonColor]
        barButtonItemAppearance.disabled.titleTextAttributes = [.foregroundColor: UIColor.gray]
        barButtonItemAppearance.highlighted.titleTextAttributes = [.foregroundColor: UIColor.label]
        barButtonItemAppearance.focused.titleTextAttributes = [.foregroundColor: buttonColor]

        customNavBarAppearance.buttonAppearance = barButtonItemAppearance
        customNavBarAppearance.backButtonAppearance = barButtonItemAppearance
        customNavBarAppearance.doneButtonAppearance = barButtonItemAppearance

        UINavigationBar.appearance().scrollEdgeAppearance = customNavBarAppearance
        UINavigationBar.appearance().compactAppearance = customNavBarAppearance
        UINavigationBar.appearance().standardAppearance = customNavBarAppearance

        if #available(iOS 15.0, *) {
            UINavigationBar.appearance().compactScrollEdgeAppearance = customNavBarAppearance
        }
    }
}
