//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Galina evdokimova on 18.07.2024.
//

import UIKit

final class ProfileViewController: UIViewController {
    
    @IBOutlet private var avatarImageView: UIImageView!
    
    @IBOutlet private var nameLabel: UILabel!
    
    @IBOutlet private var loginNameLabel: UILabel!
    
    @IBOutlet private var descriptionLabel: UILabel!
    
    @IBOutlet private var logoutButton: UIButton!
    
    @IBAction private func didTapLogoutButton() {
    }
}
