//
//  Article.swift
//  MikeKalabaySpace
//
//  Created by Mikhail Kalabai on 22.12.2023.
//

import Foundation

struct Article: Codable {
    let id: Int
    let title: String
    let url: String
    let image_url: String
    let news_site: String
    let summary: String
    let published_at: String
    let updated_at: String
    
    var Date: Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        return dateFormatter.date(from: updated_at)
    }
}

