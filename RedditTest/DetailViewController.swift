//
//  DetailViewController.swift
//  RedditTest
//
//  Created by luciano on 04/05/2020.
//  Copyright © 2020 Egg. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var articleTitle: UILabel!
    @IBOutlet weak var articleImage: UIImageView!
    @IBOutlet weak var articleAuthor: UILabel!
    @IBOutlet weak var backgroundImage: UIImageView!

    var networking: Networking = Networking()
    var articleData: ArticleData?

//    func configureView() {
        // Update the user interface for the detail item.
//        if let detail = detailItem {
//            if let label = detailDescriptionLabel {
//                label.text = detail.timestamp!.description
//            }
//        }
//    }

    func configureView() {
        // Update the user interface for the detail item.
        self.articleAuthor.text = articleData?.author
        self.articleTitle.text = articleData?.title
        if let image = articleData?.url {
            networking.loadImage(image: image) { image in
                DispatchQueue.main.async {
                    self.articleImage.image = image
                }
            }
        } else {
            self.articleImage.image = UIImage(named: "NoImage")
        }

    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
       configureView()
    }

    @IBAction func saveImage(_ sender: Any) {
        UIImageWriteToSavedPhotosAlbum(self.articleImage.image!, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }

    @objc func image(_ image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            // we got back an error!
            let ac = UIAlertController(title: NSLocalizedString("Error", comment: ""), message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default))
            present(ac, animated: true)
        } else {
            let ac = UIAlertController(title: NSLocalizedString("Saved!", comment: ""), message: NSLocalizedString("The screenshot has been saved to your photos.", comment: ""), preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default))
            present(ac, animated: true)
        }
    }

}

