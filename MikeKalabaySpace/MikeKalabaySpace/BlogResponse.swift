//
//  BlogResponse.swift
//  MikeKalabaySpace
//
//  Created by Mikhail Kalabai on 22.12.2023.
//

import Foundation

struct BlogResponse: Codable {
    let count: Int
    let next: String?
    let results: [Blog]
}
