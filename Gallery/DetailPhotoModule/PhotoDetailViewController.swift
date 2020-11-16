//
//  PhotoDetailViewController.swift
//  Gallery
//
//  Created by Vladimir on 13.11.2020.
//  Copyright © 2020 Vladimir. All rights reserved.
//

import UIKit

class PhotoDetailViewController: UIViewController {
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var imageSizeLabel: UILabel!
    @IBOutlet weak var authorName: UILabel!
    @IBOutlet weak var findAuthorButton: UIButton!
    
    var imagee: UIImage?
    var photoDetail: Photo?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController!.navigationBar.tintColor = UIColor.gray

        authorName.text = photoDetail?.author
        imageSizeLabel.text = "\(String(photoDetail!.width)) x \(String(photoDetail!.height))" 
        
        findAuthorButton.layer.cornerRadius = 15
        
        let width = UIScreen.main.bounds.width
        image.image = imagee
        image.contentMode = .scaleAspectFit
        image.frame = CGRect(x: 0, y: 0, width: width, height: image.bounds.height * width/image.bounds.width)
        
        print(image.hashValue)
    }
    
    @IBAction func findAuthorsPhotos(_ sender: Any) {
        let vc = UIStoryboard(name: "SearchViewController", bundle: nil).instantiateViewController(withIdentifier: "SearchViewController") as! SearchViewController
        vc.lext = photoDetail?.author
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func imageTapped(sender: AnyObject) {
        let vc = UIStoryboard(name: "DetailedViewController", bundle: nil).instantiateViewController(withIdentifier: "DetailedViewController") as! DetailedViewController
        vc.image = imagee
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
