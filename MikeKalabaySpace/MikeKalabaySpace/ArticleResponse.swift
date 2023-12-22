//
//  ArticleResponse.swift
//  MikeKalabaySpace
//
//  Created by Mikhail Kalabai on 22.12.2023.
//

import Foundation

struct ArticleResponse: Codable {
    let count: Int
    let next: String?
    let previous: String?
    let results: [Article]
}
