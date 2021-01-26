//
//  SongDetailViewController.swift
//  itunesApp
//
//  Created by Ignacio Segui on 24/01/2021.
//

import UIKit
import SDWebImage

class SongDetailViewController: UIViewController {
    
    @IBOutlet var getToKnowAlbum: UILabel!
    @IBOutlet var artImage: UIImageView!
    @IBOutlet var bandName: UILabel!
    @IBOutlet var albumName: UILabel!
    @IBOutlet var tableView: UITableView!
    var details: Any?
    var albumArray: Array<Any>?

    init(details: Any) {
        super.init(nibName: nil, bundle: nil)
        self.details = details
    }
    
    required init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.navigationBar.prefersLargeTitles = false
        title = (details as AnyObject).value(forKey: "trackName") as? String ?? ""
        self.navigationController?.isNavigationBarHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18)]
        tableView.register(SongDetailTableViewCell.self, forCellReuseIdentifier:"songDetailCell")
        tableView.separatorStyle = .singleLine
        tableView.delegate = self
        tableView.dataSource = self
        view.backgroundColor = .systemBackground
    }
    
    override func viewDidAppear(_ animated: Bool) {
        loadImage()
    }
    
    func setupViews() {
        let collectionName = (details as AnyObject).value(forKey: "collectionName") as? String ?? ""
        albumName.text = collectionName
        let artistName = (details as AnyObject).value(forKey: "artistName") as? String ?? ""
        bandName.text = artistName
        getToKnowAlbum.text = "Get to know the full song list of \(collectionName)"
    }
    
    func loadImage() {
        let url = URL(string: (details as AnyObject).value(forKey: "artworkUrl100") as? String ?? "")
        artImage.sd_imageIndicator = SDWebImageActivityIndicator.gray
        artImage.sd_setImage(with: url, completed: nil)
        artImage.contentMode = .scaleAspectFit
    }
}

extension SongDetailViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "songDetailCell", for: indexPath) as! SongDetailTableViewCell
        let data = albumArray?[indexPath.row]
        cell.textLabel?.text = (data as AnyObject).value(forKey: "trackName") as? String
        cell.textLabel?.numberOfLines = 1
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

