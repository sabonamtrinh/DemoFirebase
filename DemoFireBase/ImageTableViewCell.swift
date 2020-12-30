//
//  ImageTableViewCell.swift
//  DemoFireBase
//
//  Created by namtrinh on 30/12/2020.
//

import UIKit

class ImageTableViewCell: UITableViewCell {

    @IBOutlet weak var imageStorage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
      
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
