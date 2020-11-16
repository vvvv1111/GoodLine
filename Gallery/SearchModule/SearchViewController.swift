//
//  SearchViewController.swift
//  Gallery
//
//  Created by Vladimir on 13.11.2020.
//  Copyright © 2020 Vladimir. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
    
    var photos:[Photo] = []
    var lext: String?
    
    @IBOutlet weak var searchTextField: UITextField!
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.register(GalleryTableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.delegate = self
        tableView.dataSource = self
        searchTextField.delegate = self
        searchTextField.text = lext
        self.navigationController!.navigationBar.tintColor = UIColor.gray
        
        hideKeyboardWhenTappedAround()
        
        if let text = lext{
            //инкапсулировать в датапровайдер
            for item in DataProvider.shared.realm.objects(PhotoModel.self).filter("author contains '\(text)'") {
                let photo = Photo(id: item.id, author: item.author, width: item.width, height: item.height, download_url: item.download_url, image: item.image)
                photos.append(photo)
            }
            tableView.reloadData()
        }
    }
    
    
    @IBAction func clearButton(_ sender: Any) {
        searchTextField.text = ""
        photos = []
        tableView.reloadData()
    }
}

extension SearchViewController: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! GalleryTableViewCell
        
        let currentImage = UIImage(data: photos[indexPath.row].image!)
        cell.mainImageView.image = currentImage
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let width = tableView.frame.size.width
        let image = UIImage(data: photos[indexPath.row].image!)
        let picture = UIImageView(image: image)
        picture.contentMode = .scaleAspectFit
        picture.frame = CGRect(x: 0, y: 0, width: width, height: image!.size.height * width/image!.size.width)
        return picture.frame.size.height
    }
    
}



extension SearchViewController: UITextFieldDelegate{
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        if let text = searchTextField.text{
            photos = []
            for item in DataProvider.shared.realm.objects(PhotoModel.self).filter("author contains '\(text)'") {
                let photo = Photo(id: item.id, author: item.author, width: item.width, height: item.height, download_url: item.download_url, image: item.image)
                photos.append(photo)
            }
            self.tableView.reloadData()
        }
        return true
    }
    
}


