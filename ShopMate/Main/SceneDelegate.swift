//
//  SceneDelegate.swift
//  ShopMate
//
//  Created by Irina Deeva on 11/02/25.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

  var window: UIWindow?

  func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    guard let windowScene = (scene as? UIWindowScene) else { return }

    let window = UIWindow(windowScene: windowScene)
    let tabBarController = UITabBarController()
    let navigationController = UINavigationController(rootViewController: ItemSearchModuleBuilder.build())

    tabBarController.viewControllers = [navigationController]

    window.rootViewController = tabBarController
    self.window = window
    window.makeKeyAndVisible()
  }
}

