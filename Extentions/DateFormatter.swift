//
//  DateFormatter.swift
//  ImageFeed
//
//  Created by Galina evdokimova on 18.11.2024.
//

import UIKit

extension DateFormatter {
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        formatter.locale = Locale(identifier: "ru_Ru")
        return formatter
    }()
}


