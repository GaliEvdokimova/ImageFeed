//
//  SplashViewController.swift
//  ImageFeed
//
//  Created by Galina evdokimova on 16.09.2024.
//

import UIKit

final class SplashViewController: UIViewController, AuthViewControllerDelegate {
    private let showAuthenticationScreenSegueIdentifier = "ShowAuthenticationScreen"
    private let service = OAuth2Service.shared
    private let storage = OAuth2TokenStorage.shared
    private var check = false
    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared
    private var profile: Profile?
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if storage.token != nil {
            switchToTabBarController()
        } else {
            performSegue(withIdentifier: showAuthenticationScreenSegueIdentifier, sender: nil)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    private func checkAuthStatus() {
        guard !check else { return }
        check = true
        if storage.token != nil {
            UIBlockingProgressHUD.show()
            fetchProfile()
            UIBlockingProgressHUD.dismiss()
            switchToTabBarController()
        } else {
            switchToAuthController()
        }
    }
    
    private func switchToAuthController() {
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        let viewController = storyboard.instantiateViewController(identifier: "AuthViewController")
        guard let authViewController = viewController as? AuthViewController else { return }
        authViewController.delegate = self
        authViewController.modalPresentationStyle = .fullScreen
        present(authViewController, animated: true)
    }
    
    private func fetchProfile() {
        profileService.fetchProfile() { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let profile):
                self.profile = profile
                self.profileImageService.fetchProfileImageURL(userName: profile.username) { _ in }
                self.switchToTabBarController()
            case .failure:
                showAlert()
            }
            UIBlockingProgressHUD.dismiss()
        }
    }
    
    private func switchToTabBarController() {
        guard let window = UIApplication.shared.windows.first else {
            fatalError("Invalid Configuration")
        }
        let tabBarController = UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(identifier: "TabBarViewController")
        window.rootViewController = tabBarController
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showAuthenticationScreenSegueIdentifier {
            guard
                let navigationController = segue.destination as? UINavigationController,
                let viewController = navigationController.viewControllers[0] as? AuthViewController
            else {
                assertionFailure("Failed to prepare for \(showAuthenticationScreenSegueIdentifier)")
                return
            }
            viewController.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String) {
        dismiss(animated: true) { [weak self] in
            guard let self else { return }
            self.fetchOAuthToken(code)
        }
    }
    
    private func fetchOAuthToken(_ code: String) {
        UIBlockingProgressHUD.show()
        service.fetchOAuthToken(code) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success:
                self.fetchProfile()
            case .failure:
                UIBlockingProgressHUD.dismiss()
                showAlert()
            }
        }
    }
    
    private func showAlert() {
        let alert = UIAlertController(
                    title: "Что-то пошло не так(",
                    message: "Не удалось войти в систему",
                    preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Ок", style: .cancel) { [weak self ] _ in
            guard let self else { return }
            switchToAuthController()
        }
        alert.addAction(alertAction)
        present(alert, animated: true)
    }
}

