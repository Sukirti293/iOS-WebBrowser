//
//  BookmarksTableViewCell.swift
//  WebBrowser
//
//  Created by Sukirti Dash on 3/19/21.
//

import UIKit

class BookmarksTableViewCell: UITableViewCell {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var url: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
