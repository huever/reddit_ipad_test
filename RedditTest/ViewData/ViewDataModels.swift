//
//  ViewDataModels.swift
//  RedditTest
//
//  Created by luciano on 07/05/2020.
//  Copyright © 2020 Egg. All rights reserved.
//

// MARK: DetailCell

extension DetailCell.ViewData {
    init(data: ArticleData) {
        let createdStr = DateFormatter().timeSince(from: NSDate(timeIntervalSince1970: TimeInterval(data.createdUTC ?? 0)))
        let commentsStr = String.init(format: NSLocalizedString("%d comments", comment: ""), data.numComments ?? 0)
        self.init(title: data.title,
                  date: createdStr,
                  numberOfComments: commentsStr,
                  author: data.author,
                  imageUrl: data.thumbnail
        )
    }
}
