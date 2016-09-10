//
//  SaveScoreViewController.swift
//  AlencarLucas_CE04
//
//  Created by Lucas Alencar on 8/22/16.
//  Copyright © 2016 Lucas Alencar. All rights reserved.
//

import UIKit
import CoreData

class SaveScoreViewController: UIViewController {

    var varTimeToCompletion = Int()
    @IBOutlet weak var timeToCompletion: UILabel!
    
    var varNumberOfMoves = Int()
    @IBOutlet weak var numberOfMoves: UILabel!
    
    var varFullName = String()
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    
    var varDateItWasFinished: NSDate!
    @IBOutlet weak var dateItWasFinished: UILabel!
    
   
    //MARK: - General Core Data Setup
    
    //Reference to AppDelegate to keep later code clean
    private let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    //ManagedObjectContext - Our Notepad. We write notes on our notepad, then save the entire notepad to the hard disk. This is our data middleman between our code and the hard drive.
    private var managedContext: NSManagedObjectContext!
    
    
    //NSEntityDescription - Is used to describe our entity from the xcdatamodeld file when creating a new NSManagedObject
    private var entityDescription: NSEntityDescription!
    
    //NSManagedObject - used to represent the Entity Type "NumTaps" that we created in our .xcdatamodeld file.
    //We use the entity description to help us build the right kind of entity
    //This is where our data lives, everything else is just setup
    private var gameData: NSManagedObject!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Get the current date
        varDateItWasFinished = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Day, .Month, .Year], fromDate: varDateItWasFinished)
      
        timeToCompletion.text = "You finished in \(varTimeToCompletion) seconds."
        numberOfMoves.text = "Number of moves: \(varNumberOfMoves)"
        dateItWasFinished.text = "\(components.month)/\(components.day)/\(components.year)"
        
        
        //MARK: - Instantiating the General Core Data Objects
        //Make sure our ManagedContext stored property is the same ManagedObject context as in our AppDelegate
        //Here I access the AppDelegate, that has access to the Icarus_CoreDataStack as CDStack, that allows me to access the - context - that is a NSManagedObjectContext
        managedContext = appDelegate.CDStack.context
        
        //Fill out our entity description
        entityDescription = NSEntityDescription.entityForName("GameData", inManagedObjectContext: managedContext)!
        
        //Use the description to create an NSManagedObject
        gameData = NSManagedObject(entity: entityDescription, insertIntoManagedObjectContext: managedContext)
        

    }

    @IBAction func saveFunction(sender: AnyObject) {
        
        //Check if the UITextFields aren't empty
        if firstName.text != "" && lastName.text != "" {
            
            varFullName = "\(firstName.text!) \(lastName.text!)"
        
            //Set value for each attribute inside the gameData entity
            gameData.setValue(varTimeToCompletion, forKey: "timeToCompletion")
            gameData.setValue(varNumberOfMoves, forKey: "numberOfMovesMade")
            gameData.setValue(varFullName, forKey: "fullName")
            gameData.setValue(varDateItWasFinished, forKey: "dateItWasFinished")
            
            //Save notepad
            appDelegate.CDStack.saveContext()
            
            self.performSegueWithIdentifier("save", sender: self)
            
        } else {
           
            if firstName.text == "" {
            
                let alert = UIAlertController(title: "First name text field is empty.", message: "Please, to save your score, input your first name.", preferredStyle: .Alert)
                let alertAction = UIAlertAction(title: "Ok", style: .Default, handler: nil)
                alert.addAction(alertAction)
                presentViewController(alert, animated: true, completion: nil)
                
            } else if lastName.text == "" {
                
                let alert = UIAlertController(title: "Last name text field is empty.", message: "Please, to save your score, input your last name.", preferredStyle: .Alert)
                let alertAction = UIAlertAction(title: "Ok", style: .Default, handler: nil)
                alert.addAction(alertAction)
                presentViewController(alert, animated: true, completion: nil)
                
            } else if firstName.text == "" && lastName.text == "" {
                
                let alert = UIAlertController(title: "Name data is empty.", message: "Please, to save your score, input your first and last name.", preferredStyle: .Alert)
                let alertAction = UIAlertAction(title: "Ok", style: .Default, handler: nil)
                alert.addAction(alertAction)
                presentViewController(alert, animated: true, completion: nil)
            }
        }
    }
}
