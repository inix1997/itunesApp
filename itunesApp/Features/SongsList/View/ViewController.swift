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
    var resultsArray: Array<iTunesServiceModel>?
    var resultsDetailArray: Array<iTunesServiceModel>?

    init(songsDetails: Array<iTunesServiceModel>) {
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
        title = "Search results"
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) -> Void in
            make.edges.equalTo(self.view)
        }
    }
    
    func getData(label: String, data: iTunesServiceModel) {
        let finalString = Constants.kSearchAlbumApiUrl.replacingOccurrences(of: "[data]", with: label)
        AF.request(finalString).responseJSON { response in
            switch response.result {
            case .success(_):
                do {
                    if let data = response.data {
                        let response = try JSONDecoder().decode(iTunesServiceModelGeneral.self, from: data)
                        self.resultsDetailArray = response.results
                    }
                } catch {
                    print(error.localizedDescription)
                }
                
                self.hideLoading()
                let viewController = UIStoryboard(name: "SongDetail", bundle: nil).instantiateViewController(withIdentifier: "SongDetailViewController") as! SongDetailViewController
                viewController.details = data
                viewController.albumArray = self.resultsDetailArray
                self.navigationController?.pushViewController(viewController, animated: true)
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
        cell.textLabel?.text = data?.trackName
        cell.textLabel?.numberOfLines = 1
        cell.detailTextLabel?.text = data?.artistName
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = resultsArray?[indexPath.row]
        showLoading()
        let albumSongs = data?.collectionName
        var finalString = albumSongs?.replacingOccurrences(of: " ", with: "+")
        finalString = finalString?.replacingOccurrences(of: "ñ", with: "n")
        finalString = finalString?.replacingOccurrences(of: "ó", with: "o")
        finalString = finalString?.replacingOccurrences(of: "á", with: "a")
        finalString = finalString?.replacingOccurrences(of: "é", with: "e")
        finalString = finalString?.replacingOccurrences(of: "í", with: "i")
        finalString = finalString?.replacingOccurrences(of: "ú", with: "u")
        finalString = finalString?.replacingOccurrences(of: "Ñ", with: "n")
        finalString = finalString?.replacingOccurrences(of: "Ó", with: "o")
        finalString = finalString?.replacingOccurrences(of: "Á", with: "a")
        finalString = finalString?.replacingOccurrences(of: "É", with: "e")
        finalString = finalString?.replacingOccurrences(of: "Í", with: "i")
        finalString = finalString?.replacingOccurrences(of: "Ú", with: "u")
        finalString = finalString?.replacingOccurrences(of: "(", with: "")
        finalString = finalString?.replacingOccurrences(of: ")", with: "")
        if let finalData = data {
            getData(label: finalString?.lowercased() ?? "", data: finalData)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
