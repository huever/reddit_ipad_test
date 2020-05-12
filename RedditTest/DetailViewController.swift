//
//  DetailViewController.swift
//  RedditTest
//
//  Created by luciano on 04/05/2020.
//  Copyright © 2020 Egg. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    var networking: Networking = Networking()
    var articleData: ArticleData?
    
    // MARK: - Outlets

    @IBOutlet weak var articleTitle: UILabel!
    @IBOutlet weak var articleImage: UIImageView! {
        didSet {
            let longPressGesture = UITapGestureRecognizer(target: self, action: #selector(saveImage(_:)))
            self.articleImage.addGestureRecognizer(longPressGesture)
        }
    }
    @IBOutlet weak var articleAuthor: UILabel!

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
       configureView()
    }

    // MARK: - Private Methods

    private func configureView() {
        // Update the user interface for the detail item.
        title = ""
        self.articleAuthor.text = articleData?.author
        self.articleTitle.text = articleData?.title
        if let image = articleData?.url {
            networking.loadImage(image: image) { image in
                DispatchQueue.main.async {
                    self.articleImage.image = image
                }
            }
        } else {
            self.articleImage.image = UIImage(named: "no-image")
        }
    }

    @objc private func saveImage(_ sender: Any) {
        UIImageWriteToSavedPhotosAlbum(self.articleImage.image!, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }

    @objc private func image(_ image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            // we got back an error!
            let ac = UIAlertController(title: NSLocalizedString("Error", comment: ""), message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default))
            present(ac, animated: true)
        } else {
            let ac = UIAlertController(title: NSLocalizedString("Saved!", comment: ""), message: NSLocalizedString("The image was saved to your photo gallery.", comment: ""), preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default))
            present(ac, animated: true)
        }
    }
}

