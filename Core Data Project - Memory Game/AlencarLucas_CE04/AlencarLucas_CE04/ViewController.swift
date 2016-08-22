//
//  ViewController.swift
//  AlencarLucas_CE04
//
//  Created by Lucas Alencar on 8/8/16.
//  Copyright © 2016 Lucas Alencar. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {    
    
    //ManageObjectContext
    var managedObjectContext: NSManagedObjectContext!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    //Pass managedObjectContext
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "playGame" {
            let destination = segue.destinationViewController as! GameViewController
            
            destination.managedObjectContext = managedObjectContext
        }
    }
}

