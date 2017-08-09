//
//  FirstTableViewCell.swift
//  SwiftCompanion
//
//  Created by Igor Chemencedji on 5/19/17.
//  Copyright © 2017 Igor Chemencedji. All rights reserved.
//

import UIKit

class FirstTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var level: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
