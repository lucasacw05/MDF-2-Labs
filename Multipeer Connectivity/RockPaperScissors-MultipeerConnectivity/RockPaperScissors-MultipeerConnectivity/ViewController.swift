//
//  ViewController.swift
//  RockPaperScissors-MultipeerConnectivity
//
//  Created by Lucas Alencar on 8/16/16.
//  Copyright © 2016 Lucas Alencar. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class ViewController: UIViewController {
    
    //Connection status label
    @IBOutlet weak var statusLabel: UILabel!
    
    //Play button
    @IBOutlet weak var playButton: UIButton!
    
    //Create the four main building blocks for Multipeer Connectivity
    var peerID: MCPeerID! //Device ID
    var session: MCSession! //Connection between devices
    var browser: MCBrowserViewController! //VC to search nearby browsers
    var advertiser: MCAdvertiserAssistant! //To help advertise to nearby MCBrowsers
    
    let serviceID = "alencar-lucas" //Channel which communication is going to go through
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Get the device name
        peerID = MCPeerID(displayName: UIDevice.currentDevice().name)
        
        //Setup session
        session = MCSession(peer: peerID)
        session.delegate = self
        
        //Setup and start advertiser
        advertiser = MCAdvertiserAssistant(serviceType: serviceID, discoveryInfo: nil, session: session)
        advertiser.start()
        
        //Disable play button by default
        playButton.enabled = false
        
        
    }
    
    override func viewDidAppear(animated: Bool) {
        //Start advertiser
        advertiser.start()
    }
    
    //Connect button
    @IBAction func connectWithFriend(sender: AnyObject) {
        //Instantiating browser
        browser = MCBrowserViewController(serviceType: serviceID, session: session)
        browser.delegate = self
        
        //Presenting the view controller
        self.presentViewController(browser, animated: true, completion: nil)
    }
    
    //Prepare for segue function
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        //Check agains the identifier
        if segue.identifier == "playTheGame" {
            //Set destination
            let destination = segue.destinationViewController as! GameViewController
            
            //Stop advertiser
            advertiser.stop()
            
            //Pass peedID and session data
            destination.peerID = peerID
            destination.session = session
        }
    }
    
    //Perform segue
    @IBAction func playWithFriend(sender: AnyObject) {
        performSegueWithIdentifier("playTheGame", sender: self)
    }
    
}

//MARK: - MCBrowserViewControllerDelegate
extension ViewController: MCBrowserViewControllerDelegate {
    
    // Notifies the delegate, when the user taps the done button.
    func browserViewControllerDidFinish(browserViewController: MCBrowserViewController) {
        browserViewController.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // Notifies delegate that the user taps the cancel button.
    func browserViewControllerWasCancelled(browserViewController: MCBrowserViewController) {
        browserViewController.dismissViewControllerAnimated(true, completion: nil)
    }
    
}


//MARK: - MCSessionDelegate
extension ViewController: MCSessionDelegate {
    
    // Remote peer changed state.
    func session(session: MCSession, peer peerID: MCPeerID, didChangeState state: MCSessionState) {
        
        //Update UI in the main queue
        dispatch_async(dispatch_get_main_queue()) {
            
            //Checking agains the connection
            if state == MCSessionState.Connected {
                //Update UI
                self.statusLabel.text = "Status: Connected"
                //Enable play button
                self.playButton.enabled = true
                //Perform segue
                self.performSegueWithIdentifier("playTheGame", sender: self)
                
                //Check against the view controller in the stack to make sure that both devices are going to perform the segue to the second view controller
                if self.navigationController?.topViewController == self.browser {
                    
                    self.performSegueWithIdentifier("playTheGame", sender: self)
                }
                
                
            //Check agains the other states and update the UI
            } else if state == MCSessionState.Connecting {
                
                self.statusLabel.text = "Status: Connecting"
                
            } else if state == MCSessionState.NotConnected {
                
                self.statusLabel.text = "Status: Not connected"
                self.playButton.enabled = false
            }
        }
    }
    
    // Received data from remote peer.
    func session(session: MCSession, didReceiveData data: NSData, fromPeer peerID: MCPeerID) {}
    
    // Received a byte stream from remote peer.
    func session(session: MCSession, didReceiveStream stream: NSInputStream, withName streamName: String, fromPeer peerID: MCPeerID) {}
    
    // Start receiving a resource from remote peer.
    func session(session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, withProgress progress: NSProgress) {}
    
    // Finished receiving a resource from remote peer and saved the content
    // in a temporary location - the app is responsible for moving the file
    // to a permanent location within its sandbox.
    func session(session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, atURL localURL: NSURL, withError error: NSError?){}
}