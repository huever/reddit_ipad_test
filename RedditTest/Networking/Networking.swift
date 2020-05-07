//
//  Networking.swift
//  RedditTest
//
//  Created by luciano on 05/05/2020.
//  Copyright © 2020 Egg. All rights reserved.
//

import Foundation
import UIKit

class Networking {

    func getTopPost(after: String = "", taskCallback: @escaping (ResposeData) -> ())  {
        let redditUrl = URL(string: "https://www.reddit.com/r/popular/top.json?after=\(after)")

        URLSession.shared.dataTask(with: redditUrl!) { (data, response
            , error) in

            guard let data = data else { return }

            do {
                let decoder = JSONDecoder()
                let redditData = try decoder.decode(RedditBase.self, from: data)
                let data = redditData.data

                taskCallback(data)
            } catch let err {
                print("Err", err)

            }
            }.resume()
    }

    func loadImage(image: String, imageLoaded: @escaping (UIImage) -> ()) {
        let url = URL(string: image)
        var request = URLRequest(url: url!)
        URLSession.shared.dataTask(with: request as URLRequest){ data,response,error in
            if let data = data, let img: UIImage = UIImage(data: data) {
                imageLoaded(img)
            }
            }.resume()
    }
}
