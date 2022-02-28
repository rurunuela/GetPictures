//
//  SearchPhotosResponse.swift
//  getPictures (iOS)
//
//  Created by Richard Urunuela on 26/02/2022.
//

import Foundation

struct ImageUrl: Codable {
    var thumb: String
    var raw: String
}
struct Photo: Identifiable, Codable {
    var id: String
    var created_at: String
    var description: String?
    var urls: ImageUrl
}
struct SearchPhotosResponse: Codable {
    var total: Int
    var total_pages: Int
    var results: [Photo]
}
