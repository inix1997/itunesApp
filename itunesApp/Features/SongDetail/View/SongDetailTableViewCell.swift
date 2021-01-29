//
//  SongDetailTableViewCell.swift
//  itunesApp
//
//  Created by Ignacio Segui on 24/01/2021.
//

import UIKit
import SnapKit

class SongDetailTableViewCell: UITableViewCell {
    
    var titleText = String()
    var subtitleText = String()
    var playButton = UIButton()
    let iconImageName = "play.fill"
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        self.addSubview(playButton)
        self.textLabel?.text = titleText
        self.textLabel?.lineBreakMode = .byClipping
        self.textLabel?.autoresizingMask = .flexibleHeight
        self.textLabel?.numberOfLines = 0
        self.detailTextLabel?.text = subtitleText
        playButton.snp.makeConstraints { (make) -> Void in
            make.right.equalTo(self.snp.right).offset(-15)
            make.top.equalTo(self.snp.top).offset(10)
        }
        textLabel?.snp.makeConstraints { (make) -> Void in
            make.right.equalTo(self.snp.right).offset(-40)
            make.top.equalTo(self.snp.top).offset(10)
            make.left.equalTo(self.snp.left)
        }
        playButton.setImage(UIImage(systemName: iconImageName), for: .normal)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

