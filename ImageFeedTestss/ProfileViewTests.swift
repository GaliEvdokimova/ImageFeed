//
//  ProfileViewTests.swift
//  ImageFeedTestss
//
//  Created by Galina evdokimova on 28.11.2024.
//

@testable import ImageFeed
import XCTest

final class ProfileViewPresenterSpy: ProfilePresenterProtocol {
    var view: ImageFeed.ProfileViewControllerProtocol?
    var viewDidLoadCalled: Bool = false
    var profile: ImageFeed.Profile?
    var avatarURL: URL?
    
    func viewDidLoad() {
        viewDidLoadCalled = true
    }
}

final class ProfileViewControllerSpy: ProfileViewControllerProtocol {
    var presenter: ImageFeed.ProfilePresenterProtocol?
    var updateAvatarCalled: Bool = false
    var updateProfileDetailsCalled: Bool = false
    
    func updateAvatar(url: URL?) {
        updateAvatarCalled = true
    }
    
    func updateProfileDetails(profile: ImageFeed.Profile?) {
        updateProfileDetailsCalled = true
    }
}

final class ProfileViewTests: XCTestCase {
    func testViewControllerCallsViewDidLoad() {
        //given
        let viewController = ProfileViewController()
        let presenter = ProfileViewPresenterSpy()
        
        viewController.presenter = presenter
        presenter.view = viewController
        
        //when
        _ = viewController.view
        
        //then
        XCTAssertTrue(presenter.viewDidLoadCalled)  //behaviour verification
    }
    
    func testPresenterUpdateAvatarCalled() {
        // given
        let viewController = ProfileViewControllerSpy()
        let presenter = ProfilePresenter(view: viewController)
        viewController.presenter = presenter
        presenter.view = viewController
        
        // when
        presenter.viewDidLoad()
        
        // then
        XCTAssertTrue(viewController.updateAvatarCalled)
    }
    
    func testPresenterUpdateProfileDetailsCalled() {
        // given
        let viewController = ProfileViewControllerSpy()
        let presenter = ProfilePresenter(view: viewController)
        viewController.presenter = presenter
        presenter.view = viewController
        
        // when
        presenter.viewDidLoad()
        
        // then
        XCTAssertTrue(viewController.updateProfileDetailsCalled)
    }
}

