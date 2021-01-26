//
//  ViewController.swift
//  itunesApp
//
//  Created by Ignacio Segui on 24/01/2021.
//

import UIKit
import SnapKit
import Alamofire
import MBProgressHUD

class ViewController: UIViewController {
    var tableView = UITableView()
    var resultsArray: Array<Any>?

    init(songsDetails: Array<Any>) {
        super.init(nibName: nil, bundle: nil)
        self.resultsArray = songsDetails
    }
    
    required init?(coder: NSCoder) {
        fatalError("Init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TableViewCell.self, forCellReuseIdentifier:"viewCell")
        tableView.separatorStyle = .none
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "Chalkduster", size: 27) ?? UIFont.systemFont(ofSize: 18)]
        definesPresentationContext = true
        setupViews()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.isHidden = false
    }
    
    func setupViews() {
        title = "Songs"
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) -> Void in
            make.edges.equalTo(self.view)
        }
    }
    
    func getData(label: String, data: Any) {
        let finalString = Constants.kSearchAlbumApiUrl.replacingOccurrences(of: "[data]", with: label)
        AF.request(finalString).responseJSON { response in
            switch response.result {
            case .success(let value):
                if let json = value as? NSDictionary {
                    if let responseValue = json["results"] as? Array<Any> {
                        self.hideLoading()
                        let viewController = UIStoryboard(name: "SongDetail", bundle: nil).instantiateViewController(withIdentifier: "SongDetailViewController") as! SongDetailViewController
                        viewController.details = data
                        viewController.albumArray = responseValue
                        self.navigationController?.pushViewController(viewController, animated: true)
                    }
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func showLoading() {
        let loadingNotification = MBProgressHUD.showAdded(to: self.view, animated: true)
        loadingNotification?.mode = MBProgressHUDMode.indeterminate
        loadingNotification?.labelText = Constants.loading
    }

    func hideLoading() {
        MBProgressHUD.hideAllHUDs(for: view, animated: true)
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resultsArray?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "viewCell", for: indexPath) as! TableViewCell
        
        let data = resultsArray?[indexPath.row]

        cell.textLabel?.text = (data as AnyObject).value(forKey: "trackName") as? String
        cell.textLabel?.numberOfLines = 1
        cell.detailTextLabel?.text = (data as AnyObject).value(forKey: "artistName") as? String
        
        let productImageView = UIImageView()
        let url = URL(string: (data as AnyObject).value(forKey: "previewUrl") as? String ?? "")
        cell.imageView?.image = productImageView.image
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = resultsArray?[indexPath.row]
        showLoading()
        let albumSongs = (data as AnyObject).value(forKey: "collectionName") as? String ?? ""
        var finalString = albumSongs.replacingOccurrences(of: " ", with: "+")
        finalString = finalString.replacingOccurrences(of: "ñ", with: "n")
        getData(label: finalString.lowercased(), data: data)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
