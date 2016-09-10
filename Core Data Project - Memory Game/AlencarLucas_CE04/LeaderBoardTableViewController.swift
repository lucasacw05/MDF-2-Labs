//
//  LeaderBoardTableViewController.swift
//  AlencarLucas_CE04
//
//  Created by Lucas Alencar on 8/22/16.
//  Copyright © 2016 Lucas Alencar. All rights reserved.
//

import UIKit
import CoreData

struct Score {
    var timeToCompletion = Int()
    var numberOfMoves = Int()
    var fullName = String()
    var date = NSDate()
}


class LeaderBoardTableViewController: UITableViewController {
    
    //Reference to AppDelegate to keep later code clean
    private let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    //ManagedObjectContext - Our Notepad. We write notes on our notepad, then save the entire notepad to the hard disk. This is our data middleman between our code and the hard drive.
    private var managedContext: NSManagedObjectContext!
    
    //NSEntityDescription - Is used to describe our entity from the xcdatamodeld file when creating a new NSManagedObject
    private var entityDescription: NSEntityDescription!
    
    private var gameData: NSManagedObject!

    var arrayOfScores = [Score]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Make sure our ManagedContext stored property is the same ManagedObject context as in our AppDelegate
        managedContext = appDelegate.CDStack.context
        
        //Fill out our entity description
        entityDescription = NSEntityDescription.entityForName("GameData", inManagedObjectContext: managedContext)!

        //Use the description to create an NSManagedObject
        gameData = NSManagedObject(entity: entityDescription, insertIntoManagedObjectContext: managedContext)
        
        
        //Fetch Request - The parameters of what you are looking for. "Search Terms"
        //Fetch Results - What the request returns
        
        let fetchRequest = NSFetchRequest(entityName: "GameData")
        
        do {
            
            if let fetchResults = try managedContext.executeFetchRequest(fetchRequest) as? [NSManagedObject] {
                
                var score = Score()
                
                //Update our stored property
                
                for theFetchResult in fetchResults {
                
                    gameData = theFetchResult
                    
                    if let completionTime = gameData.valueForKey("timeToCompletion") {
                        score.timeToCompletion = completionTime as! Int
                    
                    } else {
                        score.timeToCompletion = 0
                    }
                    print("Time to Completion: \(score.timeToCompletion)")
                    
                    
                    
                    if let moves = gameData.valueForKey("numberOfMovesMade") {
                        score.numberOfMoves = moves as! Int
                    
                    } else {
                        score.numberOfMoves = 0
                    }
                    print("Moves: \(score.numberOfMoves)")
                    
                    
                    
                    if let fullName = gameData.valueForKey("fullName") {
                        score.fullName = (fullName as! String)
                    
                    } else {
                        score.fullName = "Default"
                    }
                    print("Name: \(score.fullName)")
                    
                    
                    if let date = gameData.valueForKey("dateItWasFinished") {
                        score.date = date as! NSDate
                    }
                    print(score.date)
                    
                    if score.fullName != "Default" {
                        arrayOfScores.append(score)
                    }
                    
                }
            }
        } catch {
            print(error)
        }
    }


    // MARK: - Table view data source
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayOfScores.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! CustomTableViewCell

        arrayOfScores.sortInPlace({$1.timeToCompletion > $0.timeToCompletion})
        
        cell.fullName.text! = (arrayOfScores[indexPath.row].fullName) as String!
        cell.numberOfMoves.text = "Moves: \(arrayOfScores[indexPath.row].numberOfMoves)"
        cell.timeToCompletion.text = "Completion Time: \(arrayOfScores[indexPath.row].timeToCompletion)"
        
        //Date
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Day, .Month, .Year], fromDate: arrayOfScores[indexPath.row].date)
        cell.date.text = "\(components.month)/\(components.day)/\(components.year)"
        

        return cell
    }
    

 
    @IBAction func backButton(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
  

}
