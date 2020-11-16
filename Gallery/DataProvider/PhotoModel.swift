//
//  PhotoModel.swift
//  Gallery
//
//  Created by Vladimir on 15.11.2020.
//  Copyright © 2020 Vladimir. All rights reserved.
//

import Foundation
import RealmSwift

public class PhotoModel: Object {
    @objc dynamic var id: String
    @objc dynamic var author: String
    @objc dynamic var width: Int
    @objc dynamic var height: Int
    @objc dynamic var download_url: String
    @objc dynamic var image: Data
    
    init(id: String, author: String,width: Int, height: Int,download_url: String, image: Data) {
        self.id = id
        self.author = author
        self.width = width
        self.height = height
        self.download_url = download_url
        self.image = image
        super.init()
    }
    
    required override init() {
        self.id = ""
        self.author = ""
        self.width = 0
        self.height = 0
        self.download_url = ""
        self.image = Data()
        super.init()
    }
}
