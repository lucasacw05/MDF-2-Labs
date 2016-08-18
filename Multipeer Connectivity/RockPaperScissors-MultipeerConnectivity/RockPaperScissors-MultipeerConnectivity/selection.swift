//
//  selection.swift
//  RockPaperScissors-MultipeerConnectivity
//
//  Created by Lucas Alencar on 8/17/16.
//  Copyright © 2016 Lucas Alencar. All rights reserved.
//

import Foundation
import UIKit
                //Conforming to NSObject protocol and NSCoding protocol
class Selection: NSObject, NSCoding {
    //Store properties
    var segment: Int
    var image: UIImage?
    var name: String
    
    init(segment: Int, image: UIImage, name: String) {
        self.segment = segment
        self.image = image
        self.name = name
    }
    
    //MARK:- NSCoding - Implementation of the required parameters. (Decoder and Encoder)
    required convenience init?(coder decoder: NSCoder) {
        let segment = decoder.decodeIntForKey("segment")
        let image = decoder.decodeObjectForKey("image") as? UIImage
        let name = decoder.decodeObjectForKey("name") as? String
        
        //Initializer
        self.init(segment: Int(segment), image: image!, name: name!)
        
    }
    
    func encodeWithCoder(coder: NSCoder) {
        coder.encodeInt(Int32(self.segment), forKey: "segment")
        coder.encodeObject(self.image, forKey: "image")
        coder.encodeObject(self.name, forKey: "name")
    }
}
