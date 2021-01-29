//
//  SongDetailViewController.swift
//  itunesApp
//
//  Created by Ignacio Segui on 24/01/2021.
//

import UIKit
import SDWebImage
import AVFoundation

class SongDetailViewController: UIViewController {
    
    @IBOutlet var getToKnowAlbum: UILabel!
    @IBOutlet var artImage: UIImageView!
    @IBOutlet var bandName: UILabel!
    @IBOutlet var albumName: UILabel!
    @IBOutlet var tableView: UITableView!
    var details: iTunesServiceModel?
    var albumArray: Array<iTunesServiceModel>?
    var player : AVPlayer?
    let cellIdentifier = "songDetailCell"
    let labelString = "Get to know the full song list of the album"
    
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
        tableView.register(SongDetailTableViewCell.self, forCellReuseIdentifier:cellIdentifier)
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
            getToKnowAlbum.text = labelString
            
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
        return albumArray?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! SongDetailTableViewCell
        let data = albumArray?[indexPath.row]
        cell.textLabel?.text = data?.trackName
        cell.textLabel?.numberOfLines = 1
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let albumItem = albumArray?[indexPath.row]
        if let urlPreview = albumItem?.previewUrl {
            let url = NSURL(string: urlPreview)
            var downloadTask: URLSessionDownloadTask
            downloadTask = URLSession.shared.downloadTask(with: url! as URL, completionHandler: { [weak self](URL, response, error) -> Void in
                do {
                    let playerItem = AVPlayerItem(url: url! as URL)
                    self?.player = try AVPlayer(playerItem:playerItem)
                    self?.player!.volume = 3.0
                    self?.player!.play()
                    let audioSession = AVAudioSession.sharedInstance()
                    try audioSession.setCategory(AVAudioSession.Category.playback, options: .duckOthers)
                } catch let error as NSError {
                    self?.player = nil
                    print(error.localizedDescription)
                } catch {
                    print("AVAudioPlayer init failed")
                }
            })
            downloadTask.resume()
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

