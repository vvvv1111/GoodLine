//
//  Photo.swift
//  Gallery
//
//  Created by Vladimir on 15.11.2020.
//  Copyright © 2020 Vladimir. All rights reserved.
//

import Foundation

struct Photo: Decodable{
    let id: String
    let author: String
    let width: Int
    let height: Int
    let download_url: String
    let image: Data?
}
