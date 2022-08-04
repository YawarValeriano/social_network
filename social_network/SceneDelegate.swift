//
//  SceneDelegate.swift
//  social_network
//
//  Created by admin on 6/29/22.
//

import UIKit
import FirebaseAuth

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    static weak var shared: SceneDelegate?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        Self.shared = self
        setupRootControllerIfNeeded()
        guard let _ = (scene as? UIWindowScene) else { return }
    }

    func setupRootControllerIfNeeded() {
        FirebaseAuthManager.shared.checkUserLoggedIn { result in
            switch result {
            case .success(()):
                let rootViewController = self.getRootViewControllerForValidUser()
                self.window?.rootViewController = rootViewController
            case .failure:
                let rootViewController = self.getRootViewControllerForInvalidUser()
                self.window?.rootViewController = rootViewController
            }
            self.window?.makeKeyAndVisible()
       }

    }

    func getRootViewControllerForInvalidUser() -> UIViewController {
        createNavController(for: LoginViewController(), title: "Sing In", image: UIImage(systemName: "newspaper.fill")!)
    }

    func getRootViewControllerForValidUser() -> UIViewController {
        // Create TabBarVC
        let tabBarVC = UITabBarController()
        tabBarVC.view.backgroundColor = .systemBackground
        UITabBar.appearance().barTintColor = .systemBackground
        tabBarVC.tabBar.tintColor = UIColor(named: "MainColor")

        // Add VCs to TabBarVC
        tabBarVC.viewControllers = [
            createNavController(for: HomeViewController(), title: "Home", image: UIImage(systemName: "house.fill")!),

            createNavController(for: FriendsViewController(), title: "Friends", image: UIImage(systemName: "person.2.fill")!),

            createNavController(for: ChatViewController(), title: "Chat", image: UIImage(systemName: "message.fill")!),

        ]

        return tabBarVC
    }

    fileprivate func createNavController(for rootViewController: UIViewController,
                                         title: String,
                                         image: UIImage) -> UIViewController {
        let navController = UINavigationController(rootViewController: rootViewController)
        navController.tabBarItem.title = title
        navController.tabBarItem.image = image

        navController.navigationBar.tintColor = .white

        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = UIColor(named: "MainColor")
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]

        navController.navigationBar.standardAppearance = appearance
        navController.navigationBar.scrollEdgeAppearance = appearance

        navController.modalPresentationStyle = .overFullScreen


        rootViewController.navigationItem.title = title


        return navController
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.

        // Save changes in the application's managed object context when the application transitions to the background.
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }


}

