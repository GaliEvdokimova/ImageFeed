//
//  TabBarController.swift
//  ImageFeed
//
//  Created by Galina evdokimova on 06.11.2024.
//

import UIKit

final class TabBarController: UITabBarController {
    override func awakeFromNib() {
        super.awakeFromNib()
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        
        let imagesListViewController = storyboard.instantiateViewController(withIdentifier: "ImagesListViewController"
        )
        let profileViewController = storyboard.instantiateViewController(identifier: "ProfileViewController"
        )
        self.viewControllers = [imagesListViewController, profileViewController]
    }
}
