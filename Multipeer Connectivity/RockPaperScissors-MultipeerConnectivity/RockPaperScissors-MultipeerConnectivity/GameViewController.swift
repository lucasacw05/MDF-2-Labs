//
//  GameViewController.swift
//  RockPaperScissors-MultipeerConnectivity
//
//  Created by Lucas Alencar on 8/16/16.
//  Copyright © 2016 Lucas Alencar. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class GameViewController: UIViewController {

    //Label and image view to represent the user's side
    @IBOutlet weak var firstPlayerLabel: UILabel!
    @IBOutlet weak var firstPlayerChoice: UIImageView!
    @IBOutlet weak var firstPlayerChoiceName: UILabel!
    @IBOutlet weak var firstPlayerScore: UILabel!
    var firstPlayerScoreInt : Int = 0
    
    //Label and image view to represent the opponent's side
    @IBOutlet weak var opponentLabel: UILabel!
    @IBOutlet weak var opponentChoice: UIImageView!
    @IBOutlet weak var opponentChoiceName: UILabel!
    @IBOutlet weak var opponentScore: UILabel!
    var opponentScoreInt : Int = 0
    
    //Button to determined if the user is sure about his choice and wants to proceed with the game.
    @IBOutlet weak var userReadyOutlet: UIButton!
    
    //Game result label
    @IBOutlet weak var gameResult: UILabel!
    
    //Segmented control to determine the user's choice
    @IBOutlet weak var usersChoice: UISegmentedControl!
    
    //Outlet for replay button
    @IBOutlet weak var replayButton: UIButton!
    
    //PeerID and Session
    var peerID: MCPeerID! //Device ID
    var session: MCSession! //Connection between devices
    
    //Default User's and opponent's selection
    var userSelection = Selection(segment: 0, image: UIImage(named: "rock1")!, name: "Rock")
    var opponentSelection = Selection(segment: 0, image: UIImage(named: "rock1")!, name: "")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Setting the title of the second VC
        self.title = "Rock-Paper-Scissors"
        //Setting up the session delegate
        session.delegate = self
        
        print(peerID)
        print(session)
        
        //Sets the initial selection of the user based on how the segmented control starts
        firstPlayerChoice.image = userSelection.image
        
        //Informative label
        gameResult.text = "Are you prepared for Battle?"
        
        //Start with replay button not showing up
        replayButton.enabled = false
        replayButton.hidden = true
    }
    
    
    
    @IBAction func replayButtonTapped(sender: AnyObject) {
        
        
        //Reset userSelection and opponent Selection
        userSelection.segment = 0
        userSelection.image = UIImage(named: "rock1")
        userSelection.name = "Rock"
        
        opponentSelection.segment = 0
        opponentSelection.image = UIImage(named: "rock1")
        opponentSelection.name = ""
        
        //Update Users Side
        firstPlayerChoice.image = userSelection.image
        firstPlayerChoiceName.text = userSelection.name
        
        //Update opponent side
        opponentChoice.image = UIImage(named: "rps")
        opponentChoiceName.text = "?"
        
        //Update segmented control
        usersChoice.selectedSegmentIndex = userSelection.segment
        usersChoice.enabled = true
        
        //Update labels
        firstPlayerLabel.text = "You"
        gameResult.text = "Are you prepared for Battle?"
        
        //Disable replay button
        replayButton.enabled = false
        replayButton.hidden = true
        
        //Enable I'm ready button
        userReadyOutlet.enabled = true
        userReadyOutlet.hidden = false
        
    }
    
    
    @IBAction func usersChoiceTapped(sender: AnyObject) {
        print("User chose index: \(usersChoice.selectedSegmentIndex)")
        
        //Switch statement to set the data of the selection according to the user input
        switch usersChoice.selectedSegmentIndex {
        case 0:
            userSelection.segment = usersChoice.selectedSegmentIndex
            userSelection.image = UIImage(named: "rock1")!
            userSelection.name = "Rock"
            
            //Also updates the image and label shown in his side of the VC
            firstPlayerChoice.image = userSelection.image
            firstPlayerChoiceName.text = userSelection.name
            
            
        case 1:
            userSelection.segment = usersChoice.selectedSegmentIndex
            userSelection.image = UIImage(named: "paper1")!
            userSelection.name = "Paper"
            
            //Also updates the image and label shown in his side of the VC
            firstPlayerChoice.image = userSelection.image
            firstPlayerChoiceName.text = userSelection.name
        
        case 2:
            userSelection.segment = usersChoice.selectedSegmentIndex
            userSelection.image = UIImage(named: "scissors1")!
            userSelection.name = "Scissor"
            //Also updates the image and label shown in his side of the VC
            firstPlayerChoice.image = userSelection.image
            firstPlayerChoiceName.text = userSelection.name
            
        default:
            break
        }
        
        
    }
    
    
    @IBAction func userReadyTapped(sender: AnyObject) {
        
        //Creates a variable to represent the selection
        var selection: AnyObject
        //Instantiates it as archived Data with root object based on the userSelection object
        selection = NSKeyedArchiver.archivedDataWithRootObject(userSelection)
        
        //Disable this button to make the user understand that you can't go back after sticking with a choice
        userReadyOutlet.enabled = false
        
        //Disable the Segmented Control for the same reason
        usersChoice.enabled = false
        
        //Send data process
        do {
            //Send               THIS data to connectedpeers through the reliable mode
            try session.sendData(selection as! NSData, toPeers: session.connectedPeers, withMode: MCSessionSendDataMode.Reliable)
            
            //Catch errors
        } catch {
            print(error)
        }
        
        //In case the user is ready and the opponent isn't, update the informative label
        gameResult.text = "Waiting for the opponent to be ready."
        
        //Checking against the opponent name and against the userReady button. If this conditional is met, it means that both the user and the opponent are ready and are going to see the result of the match.  It is important to notice that this If check happens twice: one when the user taps the "I'm Ready" button and sends the data, and the other one when the user receives the data. Thinking this way allowed me to always make them to be in the correct spot also knowing what is happening in the other side with their opponent.
        if (self.opponentSelection.name != "") && (self.userReadyOutlet.enabled == false) {
            
            self.opponentChoice.image = opponentSelection.image
            self.opponentChoiceName.text = opponentSelection.name
            
            //This is to check if there was any Tie.
            if (self.userSelection.segment == 0) && (self.opponentSelection.segment == 0) || (self.userSelection.segment == 1) && (self.opponentSelection.segment == 1) || (self.userSelection.segment == 2) && (self.opponentSelection.segment == 2){
                
                self.gameResult.text = "What a Great TIE!!!"
            
                
                //If user chooses rock and opponent paper
            } else if (self.userSelection.segment == 0) && (self.opponentSelection.segment == 1) {
                
                self.gameResult.text = "Paper dominates Rock and Wins!"
                self.firstPlayerLabel.text = "You Lost!"
                self.opponentScoreInt += 1
                self.opponentScore.text = "Score: \(self.opponentScoreInt)"
                
                
                //If user chooses paper and opponent rock
            } else if (self.userSelection.segment == 1) && (self.opponentSelection.segment == 0) {
                
                self.gameResult.text = "Paper dominates Rock and Wins!"
                self.firstPlayerLabel.text = "You Won!"
                self.firstPlayerScoreInt += 1
                self.firstPlayerScore.text = "Score: \(self.firstPlayerScoreInt)"
                
                
                
                //If user chooses rock and opponent scissors
            } else if (self.userSelection.segment == 0) && (self.opponentSelection.segment == 2) {
                
                self.gameResult.text = "Rock Smashes Scissors!"
                self.firstPlayerLabel.text = "You Won!"
                self.firstPlayerScoreInt += 1
                self.firstPlayerScore.text = "Score: \(self.firstPlayerScoreInt)"

                
                //If user chooses scissors and opponent rock
            } else if (self.userSelection.segment == 2) && (self.opponentSelection.segment == 0) {
                
                self.gameResult.text = "Rock Smashes Scissors!!"
                self.firstPlayerLabel.text = "You Lost!"
                self.opponentScoreInt += 1
                self.opponentScore.text = "Score: \(self.opponentScoreInt)"
                
                
                
                //If user chooses scissors and opponent paper
            } else if (self.userSelection.segment == 2) && (self.opponentSelection.segment == 1) {
                
                self.gameResult.text = "Scissors cuts Paper!!"
                self.firstPlayerLabel.text = "You Won!"
                self.firstPlayerScoreInt += 1
                self.firstPlayerScore.text = "Score: \(self.firstPlayerScoreInt)"
                
                
                //If user chooses paper and opponent scissors
            } else if (self.userSelection.segment == 1) && (self.opponentSelection.segment == 2) {
                
                self.gameResult.text = "Scissors cuts Paper!!"
                self.firstPlayerLabel.text = "You Lost!"
                self.opponentScoreInt += 1
                self.opponentScore.text = "Score: \(self.opponentScoreInt)"
                
                
            }
            
            //Hide userReadyButton
            self.userReadyOutlet.hidden = true
            
            //Enable replay button
            self.replayButton.enabled = true
            self.replayButton.hidden = false
        }
    }
}

extension GameViewController: MCSessionDelegate {
    
    
    // Remote peer changed state.
    func session(session: MCSession, peer peerID: MCPeerID, didChangeState state: MCSessionState) {
    }
    
    //Function for receiving data
    func session(session: MCSession, didReceiveData data: NSData, fromPeer peerID: MCPeerID) {
    
        
        //Optional biding to make sure the object exists and won't crash the app
        if let opponentData = NSKeyedUnarchiver.unarchiveObjectWithData(data) as? Selection {
            
            //Optional biding in the image to make sure it exists and won't crash the app
            if opponentData.image != nil {
                
                //Setting up the data of the variable that holds the data of the opponent
                opponentSelection.name = opponentData.name
                opponentSelection.image = opponentData.image
                opponentSelection.segment = opponentData.segment
                
            }
            
            dispatch_async(dispatch_get_main_queue(), { 
                
                //Update informative label
                self.gameResult.text = "Your opponent is ready."
                
                //Checking against the opponent name and against the userReady button. If this conditional is met, it means that both the user and the opponent are ready and are going to see the result of the match. It is important to notice that this If check happens twice: one when the user taps the "I'm Ready" button and sends the data, and the other one when the user receives the data. Thinking this way allowed me to always make them to be in the correct spot also knowing what is happening in the other side with their opponent.
                if (self.opponentSelection.name != "") && (self.userReadyOutlet.enabled == false) {
                
                    self.opponentChoice.image = opponentData.image
                    self.opponentChoiceName.text = self.opponentSelection.name
                    
                    //This is to check if there was any Tie.
                    if (self.userSelection.segment == 0) && (self.opponentSelection.segment == 0) || (self.userSelection.segment == 1) && (self.opponentSelection.segment == 1) || (self.userSelection.segment == 2) && (self.opponentSelection.segment == 2){
                        
                        self.gameResult.text = "What a Great TIE!!!"
                    
                        //If user chooses rock and opponent paper
                    } else if (self.userSelection.segment == 0) && (self.opponentSelection.segment == 1) {
                        
                        self.gameResult.text = "Paper dominates Rock and Wins!"
                        self.firstPlayerLabel.text = "You Lost!"
                        self.opponentScoreInt += 1
                        self.opponentScore.text = "Score: \(self.opponentScoreInt)"
                        
                        
                        //If user chooses paper and opponent rock
                    } else if (self.userSelection.segment == 1) && (self.opponentSelection.segment == 0) {
                        
                        self.gameResult.text = "Paper dominates Rock and Wins!"
                        self.firstPlayerLabel.text = "You Won!"
                        self.firstPlayerScoreInt += 1
                        self.firstPlayerScore.text = "Score: \(self.firstPlayerScoreInt)"
                        
                        
                        //If user chooses rock and opponent scissors
                    } else if (self.userSelection.segment == 0) && (self.opponentSelection.segment == 2) {
                        
                        self.gameResult.text = "Rock Smashes Scissors!"
                        self.firstPlayerLabel.text = "You Won!"
                        self.firstPlayerScoreInt += 1
                        self.firstPlayerScore.text = "Score: \(self.firstPlayerScoreInt)"
                        
                        
                        //If user chooses scissors and opponent rock
                    } else if (self.userSelection.segment == 2) && (self.opponentSelection.segment == 0) {
                        
                        self.gameResult.text = "Rock Smashes Scissors!!"
                        self.firstPlayerLabel.text = "You Lost!"
                        self.opponentScoreInt += 1
                        self.opponentScore.text = "Score: \(self.opponentScoreInt)"
                        
                        
                        //If user chooses scissors and opponent paper
                    } else if (self.userSelection.segment == 2) && (self.opponentSelection.segment == 1) {
                        
                        self.gameResult.text = "Scissors cuts Paper!!"
                        self.firstPlayerLabel.text = "You Won!"
                        self.firstPlayerScoreInt += 1
                        self.firstPlayerScore.text = "Score: \(self.firstPlayerScoreInt)"
                        
                        
                        //If user chooses paper and opponent scissors
                    } else if (self.userSelection.segment == 1) && (self.opponentSelection.segment == 2) {
                        
                        self.gameResult.text = "Scissors cuts Paper!!"
                        self.firstPlayerLabel.text = "You Lost!"
                        self.opponentScoreInt += 1
                        self.opponentScore.text = "Score: \(self.opponentScoreInt)"
                        
                    }
                    //Hide userReadyButton
                    self.userReadyOutlet.hidden = true
                    
                    //Enable replay button
                    self.replayButton.enabled = true
                    self.replayButton.hidden = false
                }
            })
        }
    }
    
    // Received a byte stream from remote peer.
    func session(session: MCSession, didReceiveStream stream: NSInputStream, withName streamName: String, fromPeer peerID: MCPeerID) {}
    
    // Start receiving a resource from remote peer.
    func session(session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, withProgress progress: NSProgress) {}
    
    // Finished receiving a resource from remote peer and saved the content
    // in a temporary location - the app is responsible for moving the file
    // to a permanent location within its sandbox.
    func session(session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, atURL localURL: NSURL, withError error: NSError?){}
}
