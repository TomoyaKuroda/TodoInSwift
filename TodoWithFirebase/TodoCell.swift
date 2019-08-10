//
//  TodoCell.swift
//  TodoWithFirebase
//
//  Created by Tomoya Kuroda on 2019/07/26.
//  Copyright © 2019 Group8. All rights reserved.
//

import UIKit

class TodoCell: UITableViewCell {

    @IBOutlet weak var todoLabel: UILabel!
    
    
    @IBOutlet weak var checkmarkImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
