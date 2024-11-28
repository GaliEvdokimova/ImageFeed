//
//  WebViewPresenterSpy.swift
//  ImageFeedTestss
//
//  Created by Galina evdokimova on 27.11.2024.
//

import ImageFeed
import UIKit

final class WebViewPresenterSpy: WebViewPresenterProtocol {
    var viewDidLoadCalled: Bool = false
    var view: WebViewViewControllerProtocol?
    
    func viewDidLoad() {
        viewDidLoadCalled = true
    }
    
    func didUpdateProgressValue(_ newValue: Double) {
        
    }
    
    func code(from url: URL) -> String? {
        return nil
    }
    
    
}
