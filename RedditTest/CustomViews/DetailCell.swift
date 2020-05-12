//
//  DetailCell.swift
//  RedditTest
//
//  Created by luciano on 05/05/2020.
//  Copyright © 2020 Egg. All rights reserved.
//

import UIKit

protocol DetailCellDelegate: class {
    func detailCellTapOnDismissButton(cell: DetailCell)
}

class DetailCell: UITableViewCell {

    static var preferredHeight: CGFloat = 160

    // MARK: Outlets

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var created: UILabel!
    @IBOutlet weak var comments: UILabel!
    @IBOutlet weak var author: UILabel!
    @IBOutlet weak var articleImage: UIImageView!
    @IBOutlet weak var dismissArticle: UIButton! {
        didSet {
            dismissArticle.titleLabel?.text = NSLocalizedString("Dismiss", comment: "Dismiss Article")
            dismissArticle.isUserInteractionEnabled = true
        }
    }
    @IBOutlet weak var articleViewed: UIView! {
        didSet {
            articleViewed.backgroundColor = .red
        }
    }

    @IBAction func dismissArticle(_ sender: Any) {
        self.delegate?.detailCellTapOnDismissButton(cell: self)
    }

    // MARK: ViewData

    public struct ViewData {
        let id: String
        let title: String
        let date: String
        let numberOfComments: String
        let author: String?
        let imageUrl: String?

        public init(id: String, title: String, date: String, numberOfComments: String, author: String?, imageUrl: String?) {
            self.id = id
            self.title = title
            self.date = date
            self.numberOfComments = numberOfComments
            self.author = author
            self.imageUrl = imageUrl
        }
    }

    var selectedCell: Bool? = false {
        didSet {
            if selectedCell == true {
                articleViewed.backgroundColor = .clear
            } else {
                articleViewed.backgroundColor = .red
            }
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

    public weak var delegate: DetailCellDelegate?

    // MARK: LifeCycle

    override func prepareForReuse() {
        super.prepareForReuse()
        articleViewed.backgroundColor = .red
    }
}
