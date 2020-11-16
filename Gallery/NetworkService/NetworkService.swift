//
//  DataProvider.swift
//  Gallery
//
//  Created by Vladimir on 13.11.2020.
//  Copyright © 2020 Vladimir. All rights reserved.
//

import Foundation
import UIKit


class NetworkService {
    
    var urlString = "https://picsum.photos/v2/list?page=1&limit=10"
    var arrayOfPhotos: [Photo] = []
    var numberOfPage = 0 {
        didSet{
            urlString = urlString.replacingOccurrences(of: "page=\(numberOfPage-1)", with: "page=\(numberOfPage)")
        }
    }
    
    
    func loadNext10Photos(completion: @escaping ([Photo]) -> Void){
        guard let url = URL(string: urlString) else {return}
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            var photos: [Photo] = []
            if data == nil{
                completion(photos)
            }
            guard let data = data else {return}
            guard error ==  nil else {return}
            do{
                for index in 0..<10{
                    try photos.append(JSONDecoder().decode([Photo].self, from: data)[index])
                }
                completion(photos)
                self.numberOfPage += 1
            }catch{
                print(error)
            }
        }
        .resume()
    }
    
    func loadImage(from photos: [Photo], completion: @escaping ([Data]) -> Void){
        var images: [Data] = []
        for i in 0..<photos.count{
            let urlString = photos[i].download_url
            guard let url = URL(string: urlString) else {return}
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                guard let data = data else {return}
                images.append(data)
                guard error ==  nil else {return}
                completion(images)
                
            }
            .resume()
        }
    }
}

