//
//  DetailCell.swift
//  RedditTest
//
//  Created by luciano on 05/05/2020.
//  Copyright © 2020 Egg. All rights reserved.
//

import UIKit

class DetailCell: UITableViewCell {

    // MARK: Outlets

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var created: UILabel!
    @IBOutlet weak var comments: UILabel!
    @IBOutlet weak var author: UILabel!
    @IBOutlet weak var articleImage: UIImageView!

    // MARK: ViewData

    public struct ViewData {
        let title: String?
        let date: String?
        let numberOfComments: String?
        let author: String?
        let imageUrl: String?

        public init(title: String?, date: String?, numberOfComments: String?, author: String?, imageUrl: String?) {
            self.title = title
            self.date = date
            self.numberOfComments = numberOfComments
            self.author = author
            self.imageUrl = imageUrl
        }
    }

    var viewData: ViewData? {
        didSet {
            guard let viewData = viewData else { return }

            self.title.text = viewData.title
            self.created.text = viewData.date
            self.comments.text = viewData.numberOfComments
            self.author.text = viewData.author

            if let imageUrl = viewData.imageUrl {
                    Networking().loadImage(image: imageUrl) { image in
                        DispatchQueue.main.async {
                            self.articleImage.image = image
                        }
                    }
            } else {
                articleImage.image = UIImage(named: "NoImage")
            }
        }
    }

    // MARK: LifeCycle

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
