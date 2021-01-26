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
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        self.textLabel?.text = titleText
        self.detailTextLabel?.text = subtitleText
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

