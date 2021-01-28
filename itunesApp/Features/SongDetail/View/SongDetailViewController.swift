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
    var details: iTunesServiceModel?
    var albumArray: Array<iTunesServiceModel>?
    
    init(details: iTunesServiceModel) {
        super.init(nibName: nil, bundle: nil)
        self.details = details
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.navigationBar.prefersLargeTitles = false
        title = details?.trackName
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
        let collectionName = details?.collectionName
        albumName.text = collectionName
        let artistName = details?.artistName
        bandName.text = artistName
        if let collectionNameFinal = collectionName {
            getToKnowAlbum.text = "Get to know the full song list of \(collectionNameFinal)"
        } else {
            getToKnowAlbum.text = "Get to know the full song list of the album"
            
        }
    }
    
    func loadImage() {
        let url = URL(string: details?.artworkUrl100 ?? "")
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
        cell.textLabel?.text = data?.trackName
        cell.textLabel?.numberOfLines = 1
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

