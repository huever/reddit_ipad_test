//
//  Article.swift
//  RedditTest
//
//  Created by luciano on 05/05/2020.
//  Copyright © 2020 Egg. All rights reserved.
//

import Foundation

struct RedditBase: Codable {
    let kind: String
    let data: ResposeData
}

struct ResposeData: Codable {
    let children: [Article]
    let after: String?
    let before: String?
}

struct Article: Codable {
    let kind: String
    let data: ArticleData
}

struct ArticleData: Codable {
    let preview: Preview?
    let id: String?
    let author: String?
    let url: String?
    let numComments: Int?
    let title: String
    let createdUTC: Int?
    let thumbnailHeight: Int?
    let thumbnailWidth: Int?
    let thumbnail: String?
    let name: String?

    enum CodingKeys: String, CodingKey {
        case thumbnailHeight = "thumbnail_height"
        case numComments = "num_comments"
        case thumbnailWidth = "thumbnail_width"
        case createdUTC = "created_utc"
        case name, thumbnail, preview, id, author, url, title
    }
}

struct Preview: Codable {
    let images: [Image]
    let enabled: Bool
}

struct Image: Codable {
    let source: Source
    let resolutions: [Source]
    let id: String
}

struct Source: Codable {
    let url: String
    let width, height: Int
}
