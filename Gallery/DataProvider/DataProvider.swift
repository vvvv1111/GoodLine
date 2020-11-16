//
//  DataProvider.swift
//  Gallery
//
//  Created by Vladimir on 14.11.2020.
//  Copyright © 2020 Vladimir. All rights reserved.
//

import Foundation
import RealmSwift

class DataProvider {
    static let shared = DataProvider()
    
    let realm: Realm = try! Realm()
    
    func realmDeleteAllClassObjects() {
        do {
            let objects = realm.objects(PhotoModel.self)
            
            try! realm.write {
                realm.delete(objects)
            }
        } catch let error as NSError {
            // handle error
            print("error - \(error.localizedDescription)")
        }
    }
    
    
    func add(photo: Photo, with image: Data) throws {
        let model = PhotoModel(id: photo.id, author: photo.author, width: photo.width, height: photo.height, download_url: photo.download_url, image: image)
        try realm.write {
            realm.add(model)
        }
    }
    
    func getAllValues() throws -> [Photo] {
        let rawValues = realm.objects(PhotoModel.self)
        print(rawValues.count)
        return Array(rawValues).map { rawValue in Photo(id: rawValue.id, author: rawValue.author, width: rawValue.width, height: rawValue.height, download_url: rawValue.download_url, image: rawValue.image) }
    }
    
    private init() { }
    
}
