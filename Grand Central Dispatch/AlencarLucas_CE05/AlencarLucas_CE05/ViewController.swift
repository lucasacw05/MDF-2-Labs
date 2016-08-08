//
//  ViewController.swift
//  AlencarLucas_CE05
//
//  Created by Lucas Alencar on 8/8/16.
//  Copyright © 2016 Lucas Alencar. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var image1: UIImageView!
    @IBOutlet weak var image2: UIImageView!
    @IBOutlet weak var image3: UIImageView!
    @IBOutlet weak var image4: UIImageView!
    @IBOutlet weak var image5: UIImageView!
    @IBOutlet weak var image6: UIImageView!
    @IBOutlet weak var image7: UIImageView!
    @IBOutlet weak var image8: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func clearAllViews(sender: AnyObject) {
        
        for image in [image1, image2, image3, image4, image5, image6, image7, image8] {
            
            image.image = UIImage(named: "solidGray")
        }
    }

    @IBAction func regularDownload(sender: AnyObject) {
    }

    @IBAction func serialDownload(sender: AnyObject) {
    }
    
    @IBAction func concurrentDownload(sender: AnyObject) {
    }
}

