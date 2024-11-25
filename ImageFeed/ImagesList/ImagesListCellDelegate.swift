//
//  ImagesListCellDelegate.swift
//  ImageFeed
//
//  Created by Galina evdokimova on 18.11.2024.
//

import UIKit

protocol ImagesListCellDelegate: AnyObject {
    func imageListCellDidTapLike(_ cell: ImagesListCell)
}
