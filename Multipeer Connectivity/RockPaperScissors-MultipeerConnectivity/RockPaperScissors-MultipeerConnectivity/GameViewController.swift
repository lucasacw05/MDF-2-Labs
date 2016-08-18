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
    
    //Label and image view to represent the opponent's side
    @IBOutlet weak var opponentLabel: UILabel!
    @IBOutlet weak var opponentChoice: UIImageView!
    
    //Button to determined if the user is sure about his choice and wants to proceed with the game.
    @IBOutlet weak var userReadyOutlet: UIButton!
    
    //Game result label
    @IBOutlet weak var gameResult: UILabel!
    
    //Segmented control to determine the user's choice
    @IBOutlet weak var usersChoice: UISegmentedControl!
    
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
    }
    
    @IBAction func usersChoiceTapped(sender: AnyObject) {
        print("User chose index: \(usersChoice.selectedSegmentIndex)")
        
        //Switch statement to set the data of the selection according to the user input
        switch usersChoice.selectedSegmentIndex {
        case 0:
            userSelection.segment = usersChoice.selectedSegmentIndex
            userSelection.image = UIImage(named: "rock1")!
            userSelection.name = "Rock"
            //Also updates the image shown in his side of the VC
            firstPlayerChoice.image = userSelection.image
            
            
        case 1:
            userSelection.segment = usersChoice.selectedSegmentIndex
            userSelection.image = UIImage(named: "paper1")!
            userSelection.name = "Paper"
            //Also updates the image shown in his side of the VC
            firstPlayerChoice.image = userSelection.image
        
        case 2:
            userSelection.segment = usersChoice.selectedSegmentIndex
            userSelection.image = UIImage(named: "scissors1")!
            userSelection.name = "Scissor"
            //Also updates the image shown in his side of the VC
            firstPlayerChoice.image = userSelection.image
            
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
        
        if (self.opponentSelection.name != "") && (self.userReadyOutlet.enabled == false) {
            
            self.opponentChoice.image = opponentSelection.image
            
            //Do checkings against who won or lost
            
            
        }
    }
}

extension GameViewController: MCSessionDelegate {
    
    
    // Remote peer changed state.
    func session(session: MCSession, peer peerID: MCPeerID, didChangeState state: MCSessionState) {
        
//        dispatch_async(dispatch_get_main_queue()) {
//
////            if self.navigationController?.visibleViewController as? ViewController == true {
////            }
//            
//            if let firstVC = self.navigationController?.viewControllers[0] as? ViewController {
//            
//            if state == MCSessionState.Connected {
//                
//                //self.statusLabel.text = "Status: Connected"
//                //self.playButton.enabled = true
//                firstVC.statusLabel.text = "ra"
//                
//            } else if state == MCSessionState.NotConnected {
//              
//                self.gameResult.text = "Connection Lost. Go back an try again."
// 
//            }
//            }
//        }
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
                
                if (self.opponentSelection.name != "") && (self.userReadyOutlet.enabled == false) {
                
                    self.opponentChoice.image = opponentData.image
                }
                
                
            })
            
        }
        
    }
    
    // Received a byte stream from remote peer.
    
    func session(session: MCSession, didReceiveStream stream: NSInputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        
    }
    
    // Start receiving a resource from remote peer.
    
    func session(session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, withProgress progress: NSProgress) {
        
    }
    
    // Finished receiving a resource from remote peer and saved the content
    // in a temporary location - the app is responsible for moving the file
    // to a permanent location within its sandbox.
    func session(session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, atURL localURL: NSURL, withError error: NSError?){
        
    }
}
