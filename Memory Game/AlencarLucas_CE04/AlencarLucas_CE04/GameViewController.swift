//
//  GameViewController.swift
//  AlencarLucas_CE04
//
//  Created by Lucas Alencar on 8/10/16.
//  Copyright © 2016 Lucas Alencar. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {

    //To count the total time
    @IBOutlet weak var Timer: UILabel!
    //Five seconds counter
    @IBOutlet weak var fiveSecCounter: UILabel!
    
    @IBOutlet var backOfTheCard: [UIImageView]!
    
    
    
    
    var isTheImageThere = false
    

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        print(R1B1front.bounds)
//        print(R1B1front.frame.origin.x)
//        print(R1B1front.frame.origin.y)
        
//        for i in backOfTheCard {
//            
//            i.image = UIImage(named: "icon1.png")
//        }
        
        var arrayOfCards = setUpImages()
        
        arrayOfCards[0].accessibilityIdentifier = "tesr"
        
        for i in 0...(backOfTheCard.count - 1) {
            
            backOfTheCard[i].image = arrayOfCards[i]
            
        }
        
    
    }

    func setUpImages() -> [UIImage] {
        
        var arrayOfCards: [UIImage] = []
        
        let alien = UIImage(named: "alien")
        
        let classy = UIImage(named: "classy")
        
        let crashDummy = UIImage(named: "Crash Dummy")
        
        let eatDust = UIImage(named: "Eat Dust")
        
        let flynHigh = UIImage(named: "Flyn High")
        
        let freeFlying = UIImage(named: "Free Flying")
        
        let heyZeus = UIImage(named: "Hey Zeus")
        
        let lionTamer = UIImage(named: "Lion Tamer")
        
        let looseChange = UIImage(named: "Loose Change")
        
        let nappn = UIImage(named: "Nappn")
        
        if let alien = alien, classy = classy, crashDummy = crashDummy, eatDust = eatDust, flynHigh = flynHigh, freeFlying = freeFlying, heyZeus = heyZeus, lionTamer = lionTamer, looseChange = looseChange, nappn = nappn {
            
            arrayOfCards = [alien, classy, crashDummy, eatDust, flynHigh, freeFlying, heyZeus, lionTamer, looseChange, nappn, alien, classy, crashDummy, eatDust, flynHigh, freeFlying, heyZeus, lionTamer, looseChange, nappn]
        }
        
        
//        let punkd = UIImage(named: "Punkd")
//        
//        let ragsToRiches = UIImage(named: "Rags to Riches")
//        
//        let spearMe = UIImage(named: "Spear Me")
//        
//        let uncharted = UIImage(named: "Uncharted")
//        
//        let warmingUp = UIImage(named: "Warming Up")
        return arrayOfCards
    }


    @IBAction func backButton(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    
    @IBAction func cardTapped(sender: AnyObject) {
        
    }
        
//        print("here")
//        
//        if isTheImageThere == false {
//            
//            ImageR1B1.image = UIImage(named: "Cave Crasher")
//            
//            isTheImageThere = true
//            
//        } else {
//            ImageR1B1.image = nil
//            isTheImageThere = false
//        }
//        
    
}
