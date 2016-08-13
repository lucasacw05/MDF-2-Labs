//
//  GameViewController.swift
//  AlencarLucas_CE04
//
//  Created by Lucas Alencar on 8/10/16.
//  Copyright © 2016 Lucas Alencar. All rights reserved.
//

import UIKit
import AVFoundation

class GameViewController: UIViewController {
    
    var pointScored = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("pointScored", ofType: "wav")!)
    var pointScoredAP = AVAudioPlayer()
    
    var click = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("click", ofType: "wav")!)
    var clickAP = AVAudioPlayer()
    
    var finish = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("finish", ofType: "wav")!)
    var finishAP = AVAudioPlayer()
    
    
    //To count the total time of the game
    @IBOutlet weak var Timer: UILabel!
    var gameTimer = NSTimer()
    var gameTimerSeconds = 0
    var gameTimerIsOn = false
    
    
    //Five seconds counter
    @IBOutlet weak var fiveSecCounter: UILabel!
    //Five second timer and countDown in seconds
    var fiveSecTimer = NSTimer()
    var countDown: Int = 5
    
    
    //Card Delay Timer Creation
    var cardDelayTimer = NSTimer()
    var cardDelayCountDown: Int = 1
    
    //All ImageViews that are going to represent the back of the cards
    @IBOutlet var backOfTheCard: [UIImageView]!
    //Image of the back of the card.
    var backOfCardImage = UIImage(named: "icon")
    
    
    //All the ImageViews that are going to represent the front of the card
    @IBOutlet var frontOfTheCard: [UIImageView]!
    
    
    //Button outlet for each card
    @IBOutlet var cardButtonOutlet: [UIButton]!
    
    //Array to hold the data of every disabled button by points scored
    var arrayOfDisabledButtons: [UIButton] = []
    
    
    var firstImageSelection: Bool = false
    var firstImageData: String = ""
    var firstImageLocation = Int()
    
    var secondImageSelection: Bool = false
    var secondImageData: String = ""
    var secondImageLocation = Int()
    
    var arrayOfCards: [UIImage] = []
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Finish setting up audio effects
        do {
            pointScoredAP = try AVAudioPlayer(contentsOfURL: pointScored)
            clickAP = try AVAudioPlayer(contentsOfURL: click)
            finishAP = try AVAudioPlayer(contentsOfURL: finish)
        } catch {
            print(error)
        }
        
        
        //        print(R1B1front.bounds)
        //        print(R1B1front.frame.origin.x)
        //        print(R1B1front.frame.origin.y)
        
        //Create array of cards
        arrayOfCards = setUpImages()
        
        //Setup Card Identifiers
        setUpAccessibilityIdentifiers()
        
        //Shuffle array each time the view loads
        arrayOfCards.shuffle()
        
        //Sets the front image of each card in the game
        for i in 0...(frontOfTheCard.count - 1) {
            frontOfTheCard[i].image = arrayOfCards[i]
        }
        
        //Five seconds count down function call
        setUp5SecCountdownTimer()
        
        
    }
    
    //Timer to count how long the user finishes the game
    func startGameTimer() {
        gameTimer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: #selector(GameViewController.updateGameTimer), userInfo: nil, repeats: true)
        
        //Allow the timer to start working properly, updating the UI
        gameTimerIsOn = true
    }
    
    //Update Timer
    func updateGameTimer() {
        
        if gameTimerIsOn == true {
            
            gameTimerSeconds += 1
            
            //Update UI based on these simple checks
            if gameTimerSeconds <= 9 {
                
                Timer.text = "Timer: 0\(gameTimerSeconds)s"
                
            } else {
                
                Timer.text = "Timer: \(gameTimerSeconds)s"
            }
            
        } else {
            //Turn off the timer
            gameTimer.invalidate()
            gameTimerIsOn = false
        }
    }
    
    //5 Seconds Timer CountDown setup
    func setUp5SecCountdownTimer() {
        //Assign value to already created NSTimer
        fiveSecTimer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: #selector(GameViewController.updateFiveSecCounter), userInfo: nil, repeats: true)
        
        //Disables every button to prevent taps while the game don't start.
        for button in cardButtonOutlet {
            button.enabled = false
        }
    }
    
    func updateFiveSecCounter() {
        
        if (countDown > 0) {
            //Subtract countDown and update UI Outlet
            countDown -= 1
            fiveSecCounter.text = String("0\(countDown)s")
            
        } else {
            
            //Make label disappear, Invalidate the 5 Sec countdown timer
            fiveSecCounter.text = nil
            fiveSecTimer.invalidate()
            
            //Start gameTimer
            startGameTimer()
            
            //Set all backOfTheCard imageViews to the backOfCardImage
            for card in 0...(backOfTheCard.count - 1) {
                backOfTheCard[card].image = backOfCardImage
            }
            
            //Enable the buttons again
            for button in cardButtonOutlet {
                button.enabled = true
            }
        }
    }
    
    
    //Card Delay Timer Setup
    func setupCardDelayTimer() {
        //Assign value to already created NSTimer
        cardDelayTimer = NSTimer.scheduledTimerWithTimeInterval(0.75, target: self, selector: #selector(GameViewController.selectionDelay), userInfo: nil, repeats: true)
        
        //Disables every button so that they won't be tapped during the card's delay time
        for button in cardButtonOutlet {
            button.enabled = false
        }
        
    }
    
    func selectionDelay() {
        
        if (cardDelayCountDown > 0) {
            cardDelayCountDown -= 1
            
            
        } else {
            
            //Invalidate timer
            cardDelayTimer.invalidate()
            
            //Enable every button again
            for button in cardButtonOutlet {
                button.enabled = true
            }
            
            //Disable every button of those matches that already happened in the game
            for button in arrayOfDisabledButtons {
                button.enabled = false
            }
            
            //Flip back the cards because they didn't match
            backOfTheCard[firstImageLocation].hidden = false
            backOfTheCard[secondImageLocation].hidden = false
            
            print("Data being reseted")
            //RESET DATA
            firstImageData = ""
            firstImageSelection = false
            firstImageLocation = 0
            
            secondImageData = ""
            secondImageSelection = false
            secondImageLocation = 0
        }
        
    }
    
    @IBAction func cardTapped(sender: AnyObject) {
        
        //Play Sound
        clickAP.play()
        
        let location = sender.tag
        
        if firstImageSelection == false {
            print("First Selection")
            
            if let identifier = arrayOfCards[location].accessibilityIdentifier {
                
                firstImageData = identifier
                print("ID:\(firstImageData)")
                
                backOfTheCard[location].hidden = true
                cardButtonOutlet[location].enabled = false
                
                firstImageSelection = true
                firstImageLocation = location
            }
            
        } else if firstImageSelection == true && secondImageSelection == false {
            print("Second Selection")
            
            if let identifier = arrayOfCards[location].accessibilityIdentifier {
                
                secondImageData = identifier
                print("ID:\(secondImageData)")
                
                backOfTheCard[location].hidden = true
                cardButtonOutlet[location].enabled = false
                
                secondImageSelection = true
                secondImageLocation = location
            }
            
            
            if firstImageSelection == true && secondImageSelection && true {
                
                //Check agains the image identifiers, and if they're equal, eliminate the card match
                if firstImageData == secondImageData {
                    
                    
                    
                    frontOfTheCard[firstImageLocation].hidden = true
                    backOfTheCard[firstImageLocation].hidden = true
                    cardButtonOutlet[firstImageLocation].enabled = false
                    
                    //Store the data of the button so that when the match doesn't happen, The timer could disable all the buttons, enable all of them again when the time is over, then disabling only those other buttons that the card match already happened, preventing the user to click something that he can't see anymore
                    let buttonOfFirstSelection = cardButtonOutlet[firstImageLocation]
                    arrayOfDisabledButtons.append(buttonOfFirstSelection)
                    
                    frontOfTheCard[secondImageLocation].hidden = true
                    backOfTheCard[secondImageLocation].hidden = true
                    cardButtonOutlet[secondImageLocation].enabled = false
                    
                    
                    //Store the data of the button so that when the match doesn't happen, The timer could disable all the buttons, enable all of them again when the time is over, then disabling only those other buttons that the card match already happened, preventing the user to click something that he can't see anymore
                    let buttonOfSecondSelection = cardButtonOutlet[secondImageLocation]
                    arrayOfDisabledButtons.append(buttonOfSecondSelection)
                    print("It worked")
                    
                    //RESET DATA
                    firstImageData = ""
                    firstImageSelection = false
                    firstImageLocation = 0
                    
                    secondImageData = ""
                    secondImageSelection = false
                    secondImageLocation = 0
                    
                    //Play pointScored sound
                    pointScoredAP.play()
                    
                    //Finish Game
                    if arrayOfDisabledButtons.count == 20  {
                        
                        //Turn off timer
                        gameTimerIsOn = false
                        
                        //Play pointScored sound
                        finishAP.play()
                        
                        //Present Alert to inform the user finished the game
                        let alert = UIAlertController(title: "Congrats!!", message: "You Finished the Game in \(gameTimerSeconds) Seconds!", preferredStyle: .Alert)
                        let alertAction = UIAlertAction(title: "Done", style: .Default, handler: nil)
                        alert.addAction(alertAction)
                        presentViewController(alert, animated: true, completion: nil)
                    }
                    
                } else {
                    
                    //Call function to cause delay in the process of choosing new cards
                    setupCardDelayTimer()
                }
                
            }
        }
    }
    
    
    //Function that sets up every image
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
            
            arrayOfCards = [alien, alien, classy, classy, crashDummy, crashDummy, eatDust, eatDust, flynHigh, flynHigh, freeFlying, freeFlying, heyZeus, heyZeus, lionTamer, lionTamer, looseChange, looseChange, nappn, nappn]
        }
        
        //FOR IPAD
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
    
    //Functions to setup all accessibility identifiers of the arrayOfCards
    func setUpAccessibilityIdentifiers() {
        
        arrayOfCards[0].accessibilityIdentifier = "alien"
        arrayOfCards[1].accessibilityIdentifier = "alien"
        
        arrayOfCards[2].accessibilityIdentifier = "classy"
        arrayOfCards[3].accessibilityIdentifier = "classy"
        
        arrayOfCards[4].accessibilityIdentifier = "Crash Dummy"
        arrayOfCards[5].accessibilityIdentifier = "Crash Dummy"
        
        arrayOfCards[6].accessibilityIdentifier = "Eat Dust"
        arrayOfCards[7].accessibilityIdentifier = "Eat Dust"
        
        arrayOfCards[8].accessibilityIdentifier = "Flyn High"
        arrayOfCards[9].accessibilityIdentifier = "Flyn High"
        
        arrayOfCards[10].accessibilityIdentifier = "Free Flying"
        arrayOfCards[11].accessibilityIdentifier = "Free Flying"
        
        arrayOfCards[12].accessibilityIdentifier = "Hey Zeus"
        arrayOfCards[13].accessibilityIdentifier = "Hey Zeus"
        
        arrayOfCards[14].accessibilityIdentifier = "Lion Tamer"
        arrayOfCards[15].accessibilityIdentifier = "Lion Tamer"
        
        arrayOfCards[16].accessibilityIdentifier = "Loose Change"
        arrayOfCards[17].accessibilityIdentifier = "Loose Change"
        
        arrayOfCards[18].accessibilityIdentifier = "Nappn"
        arrayOfCards[19].accessibilityIdentifier = "Nappn"
        
        //TODO: - Setup the iPad ones
    }
    
    //Back button to initial VC
    @IBAction func backButton(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}


extension Array {
    mutating func shuffle() {
        
        for _ in 0..<10
        {
            sortInPlace { (_,_) in arc4random() < arc4random() }
        }
    }
}