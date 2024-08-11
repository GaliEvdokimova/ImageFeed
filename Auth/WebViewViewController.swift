//
//  WebViewViewController.swift
//  ImageFeed
//
//  Created by Galina evdokimova on 11.08.2024.
//

import UIKit
import WebKit

fileprivate let UnsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"

protocol WebViewViewControllerDelegate: AnyObject {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String)
    func webViewViewControllerDidCancel(_ vc: WebViewViewController)
}

final class WebViewViewController: UIViewController {
    
    @IBOutlet private var webView: WKWebView!
    
    weak var delegate: WebViewViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.navigationDelegate = self
        var urlComponents = URLComponents(string: UnsplashAuthorizeURLString)!
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: AccessKey),
            URLQueryItem(name: "redirect_uri", value: RedirectURI),
            URLQueryItem(name: "response_type", value: "code"),
            URLQueryItem(name: "scope", value: AccessScope)
        ]
        let url = urlComponents.url!
        
        let request = URLRequest(url: url)
        webView.load(request)
    }
    
    @IBAction private func didTapBackButton(_ sender: Any?) {
        delegate?.webViewViewControllerDidCancel(self)
    }
}
    
extension WebViewViewController: WKNavigationDelegate {
    func webView(
        _ webView: WKWebView,
        decidePolicyFor navigationAction: WKNavigationAction,
        decisionHandler: @escaping (WKNavigationActionPolicy) -> Void
    ) {
        if code(from: navigationAction) != nil {
            //TODO: process code
            decisionHandler(.cancel)
        } else {
            decisionHandler(.allow)
        }
    }
        private func code(from navigationAction: WKNavigationAction) -> String? {
            if
                let url = navigationAction.request.url,
                let urlComponents = URLComponents(string: url.absoluteString),
                urlComponents.path == "/oauth/authorize/native",
                let items = urlComponents.queryItems,
                let codeItem = items.first(where: { $0.name == "code"})
            {
                return codeItem.value
            } else {
                return nil
            }
        }
    }
//    enum WebViewConstants {
//        static let unsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"
//    }
    
//    private func loadAuthView() {
//        guard var urlComponents = URLComponents(string: WebViewConstants.unsplashAuthorizeURLString) else {
//            return
//        }
//        urlComponents.queryItems = [
//            URLQueryItem(name: "client_id", value: AccessKey),                  //2
//            URLQueryItem(name: "redirect_uri", value: RedirectURI),             //3
//            URLQueryItem(name: "response_type", value: "code"),                 //4
//            URLQueryItem(name: "scope", value: AccessScope)
//        ]
//        
//        guard let url = urlComponents.url else {
//            return
//        }
//        
//        let request = URLRequest(url: url)
//        webView.load(request)
        
       
    
