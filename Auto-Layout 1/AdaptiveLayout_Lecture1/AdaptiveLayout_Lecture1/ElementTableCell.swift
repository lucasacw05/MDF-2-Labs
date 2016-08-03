//
//  ElementTableCell.swift
//  AdaptiveLayout_Lecture1_Complete


import Foundation
import UIKit

class ElementTableViewCell: UITableViewCell {
    
    //Cell outlets
    @IBOutlet weak var m_symbol: UILabel!
    @IBOutlet weak var m_name: UILabel!
    
    //Function for setting up the outlets.
    func setupCell(symbol: String, name: String) {
        m_symbol.text = symbol;
        m_name.text = name;
    }
    
}
