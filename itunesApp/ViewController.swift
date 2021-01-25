//
//  ViewController.swift
//  itunesApp
//
//  Created by Ignacio Segui on 24/01/2021.
//

import UIKit
import SnapKit
import Alamofire

class ViewController: UIViewController {
    var tableView = UITableView()
    var resultsArray: Array<Any>?

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TableViewCell.self, forCellReuseIdentifier:"viewCell")
        tableView.separatorStyle = .none
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "Chalkduster", size: 27) ?? UIFont.systemFont(ofSize: 18)]
        definesPresentationContext = true
        setupViews()
        getData()
    }

    func setupViews() {
        title = "Music"
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) -> Void in
            make.edges.equalTo(self.view)
        }
    }
    
    func getData() {
        AF.request(Constants.kSearchApiUrl).responseJSON { response in
            switch response.result {
            case .success(let value):
                if let json = value as? NSDictionary {
                    if let responseValue = json["results"] as? Array<Any> {
                        self.resultsArray = responseValue
                        self.tableView.reloadData()
                    }
                }
            case .failure(let error):
                print(error)
            }
            self.view.bringSubviewToFront(self.tableView)
        }
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
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
