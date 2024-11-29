//
//  ImagesListPresenter.swift
//  ImageFeed
//
//  Created by Galina evdokimova on 28.11.2024.
//

import UIKit

protocol ImagesListPresenterProtocol: AnyObject {
    var imagesListService: ImagesListService { get }
    var view: ImagesListViewControllerProtocol? { get set }
    func viewDidLoad()
    func fetchPhotosNextPage()
    func changeLike(photoId: String,
                    isLike: Bool,
                    _ completion: @escaping (Result<Void, Error>) -> Void
    )
}

final class ImagesListPresenter: ImagesListPresenterProtocol {
    weak var view: ImagesListViewControllerProtocol?
    let imagesListService = ImagesListService.shared
    private var imageListServiceObserver: NSObjectProtocol?
    
    func viewDidLoad() {
        imageListServiceObserver = NotificationCenter.default
            .addObserver(
                forName: ImagesListService.didChangeNotification,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                guard let self else { return }
                view?.updateTableViewAnimated()
            }
        imagesListService.fetchPhotosNextPage()
    }
    
    func fetchPhotosNextPage() {
        imagesListService.fetchPhotosNextPage()
    }
    
    func changeLike(
        photoId: String,
        isLike: Bool,
        _ completion: @escaping (Result<Void, Error>) -> Void
    ) {
        imagesListService.changeLike(photoId: photoId, isLike: isLike, { [weak self ] result in
            guard let self else { return }
            switch result{
                case .success(_):
                    completion(.success(()))
                case .failure(let error):
                    completion(.failure(error))
                    print(error.localizedDescription)
            }
        })
    }
}
