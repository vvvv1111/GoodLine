//
//  TableViewController.swift
//  Gallery
//
//  Created by Vladimir on 13.11.2020.
//  Copyright © 2020 Vladimir. All rights reserved.
//

//протекает обстракция, доинкапсулировать методы загрузки данных

import UIKit

class GalleryTableViewController: UITableViewController {
    
    fileprivate var activityIndicator: LoadMoreActivityIndicator!
    fileprivate var firstLoadActivityIndicator = UIActivityIndicatorView(style: .large)
    
    let networkService = NetworkService()
    var firstLaunch = true
    var photos: [Photo] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setAlctivityIndicatorUI()
        setBarButtonItemUI()
        loadNext10PhotosAndSaveToDB()
        presentAlert()
        
    }
    
    
    func presentAlert(){
        let alert = UIAlertController(title: "Привет", message: "Здравствуй, коллега! В принципе реализовал весь требуемый функционал, юзал не 500px как вы советовали в тз так как бесплатного апи у сервиса нет с 2018 года. Остался небольшой косяк с лейаутом в дитейлВью и две явные, но легкоисправимые добавлением метода поиска элемента в дб протечки абстракции в двух вьюхах. плюс, нужно обязательно сжимать фотки которые юзает тейблвью чтобы прокрутка была плавнее. и перепроверить работу с потоками. в целом тестовое крутое, оч кайфанул пока дела, вне зависимости от результата спасибо.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "хорошо", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "плохо", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func setBarButtonItemUI(){
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Search", style: .plain, target: self, action: #selector(transitionToSearch))
        navigationItem.rightBarButtonItem?.tintColor = UIColor.gray
    }
    
    @objc func transitionToSearch(){
        let vc = UIStoryboard(name: "SearchViewController", bundle: nil).instantiateViewController(withIdentifier: "SearchViewController")
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func setAlctivityIndicatorUI(){
        tableView.tableFooterView = UIView()
        activityIndicator = LoadMoreActivityIndicator(scrollView: tableView, spacingFromLastCell: 10, spacingFromLastCellWhenLoadMoreActionStart: 60)
        self.tableView.register(GalleryTableViewCell.self, forCellReuseIdentifier: "cell")
        firstLoadActivityIndicator.center = self.view!.center
        firstLoadActivityIndicator.startAnimating()
        tableView.addSubview(firstLoadActivityIndicator)
    }
    
    func loadNext10PhotosAndSaveToDB() {
        networkService.loadNext10Photos { (photos) in
            if photos.count == 0 {
                DispatchQueue.main.async {
                    self.photos = (try? DataProvider.shared.getAllValues())!
                    self.tableView.reloadData()
                    self.firstLoadActivityIndicator.stopAnimating()
                }
            }else{
                self.networkService.loadImage(from: photos) { (images) in
                    if images.count == 10{
                        DispatchQueue.main.async {
                            if self.firstLaunch == true{
                                DataProvider.shared.realmDeleteAllClassObjects()
                                self.firstLaunch = false
                            }
                            for i in 0..<10{
                                try? DataProvider.shared.add(photo: photos[i], with: images[i])
                            }
                            let o = try? DataProvider.shared.getAllValues()
                            self.photos.append(contentsOf: o!)
                            self.activityIndicator.stop()
                            self.firstLoadActivityIndicator.stopAnimating()
                            self.tableView.reloadData()
                        }
                    }
                }
            }
            
        }
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        activityIndicator.start {
            self.loadNext10PhotosAndSaveToDB()
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photos.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! GalleryTableViewCell
        let currentImage = UIImage(data: photos[indexPath.row].image!)
        cell.mainImageView.image = currentImage
        
        return cell
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let currentImage = UIImage(data: photos[indexPath.row].image!)
        let imageRatio = currentImage!.getImageRatio()
        return tableView.frame.width / imageRatio
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = UIStoryboard(name: "PhotoDetailViewController", bundle: nil).instantiateViewController(withIdentifier: "PhotoDetailViewController") as! PhotoDetailViewController
        
        vc.photoDetail = photos[indexPath.row]
        vc.imagee = UIImage(data: photos[indexPath.row].image!)
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
}


