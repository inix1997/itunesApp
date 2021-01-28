//
//  MainViewController.swift
//  itunesApp
//
//  Created by Ignacio Segui on 24/01/2021.
//

import Foundation
import SnapKit
import Alamofire
import MBProgressHUD
import SwiftyGif
import MaterialComponents

class MainViewController: UIViewController {
    var resultsArray: Array<iTunesServiceModel>?
    var welcomeLabel = UILabel()
    var confirmButton = MDCButton()
    let textField = MDCFilledTextArea()
    
    var welcomeText = "WELCOME!"
    var descriptionLabelText = "Type something to search"
    var searchText = "Search"
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    func setupViews() {
        view.addSubview(welcomeLabel)
        view.addSubview(textField)
        view.addSubview(confirmButton)
        view.backgroundColor = .systemBackground
        
        welcomeLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(self.view.snp.top).offset(100)
            make.centerX.equalTo(self.view)
        }
        
        textField.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(self.welcomeLabel.snp.bottom).offset(50)
            make.centerX.equalTo(self.view)
            make.width.equalTo(300)
        }
        
        confirmButton.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(self.textField.snp.bottom).offset(50)
            make.centerX.equalTo(self.view)
            make.height.equalTo(50)
            make.width.equalTo(200)
        }
        
        textField.label.text = descriptionLabelText
        textField.sizeToFit()
        
        welcomeLabel.text = welcomeText
        welcomeLabel.font = UIFont(name: "Chalkduster", size: 50)
        
        confirmButton.setTitle(searchText, for: .normal)
        confirmButton.addTarget(self, action: #selector(confirmButtonAction), for: .touchUpInside)
        confirmButton.setTitleColor(.black, for: .normal)
        confirmButton.backgroundColor = .systemPurple
        confirmButton.alpha = 2
        
        do {
            let gif = try UIImage(gifName: "music.gif")
            let imageview = UIImageView(gifImage: gif)
            view.addSubview(imageview)
            imageview.snp.makeConstraints { (make) -> Void in
                make.top.equalTo(self.view.bounds.height/2)
                make.bottom.equalTo(self.view.snp.bottom)
                make.left.equalTo(self.view.snp.left)
                make.right.equalTo(self.view.snp.right)
            }
            imageview.alpha = 0.65
        } catch {
            print(error)
        }
    }
    
    @objc func confirmButtonAction() {
        showLoading()
        if let textFieldString = textField.textView.text, textFieldString != "" {
            var finalString = textFieldString.replacingOccurrences(of: " ", with: "+")
            finalString = finalString.replacingOccurrences(of: "ñ", with: "n")
            finalString = finalString.replacingOccurrences(of: "ó", with: "o")
            finalString = finalString.replacingOccurrences(of: "á", with: "a")
            finalString = finalString.replacingOccurrences(of: "é", with: "e")
            finalString = finalString.replacingOccurrences(of: "í", with: "i")
            finalString = finalString.replacingOccurrences(of: "ú", with: "u")
            finalString = finalString.replacingOccurrences(of: "Ñ", with: "n")
            finalString = finalString.replacingOccurrences(of: "Ó", with: "o")
            finalString = finalString.replacingOccurrences(of: "Á", with: "a")
            finalString = finalString.replacingOccurrences(of: "É", with: "e")
            finalString = finalString.replacingOccurrences(of: "Í", with: "i")
            finalString = finalString.replacingOccurrences(of: "Ú", with: "u")
            finalString = finalString.replacingOccurrences(of: "(", with: "")
            finalString = finalString.replacingOccurrences(of: ")", with: "")
            getData(label: finalString.lowercased())
        } else {
            hideLoading()
        }
    }
    
    func getData(label: String) {
        let finalString = Constants.kSearchSongApiUrl.replacingOccurrences(of: "[data]", with: label)
        AF.request(finalString).responseJSON { response in
            switch response.result {
            case .success(_):
                do {
                    if let data = response.data {
                        let response = try JSONDecoder().decode(iTunesServiceModelGeneral.self, from: data)
                        self.resultsArray = response.results
                    }
                } catch {
                    print(error.localizedDescription)
                }
                self.hideLoading()
                let viewController = ViewController(songsDetails: self.resultsArray ?? [])
                self.navigationController?.pushViewController(viewController, animated: true)
            case .failure(let error):
                self.hideLoading()
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
