//
//  CustomTableViewCell.swift
//  AlencarLucas_CE04
//
//  Created by Lucas Alencar on 8/24/16.
//  Copyright © 2016 Lucas Alencar. All rights reserved.
//

import UIKit

class CustomTableViewCell: UITableViewCell {

    @IBOutlet weak var fullName: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var timeToCompletion: UILabel!
    @IBOutlet weak var numberOfMoves: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    

}
