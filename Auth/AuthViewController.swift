//
//  AuthViewController.swift
//  ImageFeed
//
//  Created by Galina evdokimova on 11.08.2024.
//

import UIKit

protocol AuthViewControllerDelegate: AnyObject {
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String)
}

final class AuthViewController: UIViewController, WebViewViewControllerDelegate {
    private let showWebViewSegueIdentifier = "ShowWebView"
    private let oAuth2Service = OAuth2Service.shared
    private let tokenStorage = OAuth2TokenStorage.shared
    weak var delegate: AuthViewControllerDelegate?
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureBackButton()
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showWebViewSegueIdentifier {
            guard
                let webViewViewController = segue.destination as? WebViewViewController
            else { fatalError("Failed to prepare for \(showWebViewSegueIdentifier)") }
            webViewViewController.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }

    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
        delegate?.authViewController(self, didAuthenticateWithCode: code)
    }

    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        dismiss(animated: true)
    }
    
    private func configureBackButton() {
        navigationController?.navigationBar.backIndicatorImage = UIImage(named: "nav_back_button")
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "nav_back_button")
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem?.tintColor? = UIColor.ypBlack
    }
}

//    private func configureBackButton() {
//        navigationController?.navigationBar.backIndicatorImage = UIImage(named: "nav_back_button_white")
//        navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "nav_back_button_white")
//        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
//        navigationItem.backBarButtonItem?.tintColor = UIColor(named: "YP Black")
//    }

