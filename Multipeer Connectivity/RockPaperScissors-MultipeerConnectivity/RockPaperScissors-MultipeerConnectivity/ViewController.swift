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
    
    @IBOutlet weak var statusLabel: UILabel!
    
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
        
        print("hey")
        
    }
    
    override func viewDidAppear(animated: Bool) {
        advertiser.start()
    }
    
    
    @IBAction func connectWithFriend(sender: AnyObject) {
        browser = MCBrowserViewController(serviceType: serviceID, session: session)
        browser.delegate = self
        
        self.presentViewController(browser, animated: true, completion: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "playTheGame" {
            
            let destination = segue.destinationViewController as! GameViewController
            
            //Stop advertiser
            advertiser.stop()
            
            destination.peerID = peerID
            destination.session = session
        }
        
        
        
    }
    
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
        
        dispatch_async(dispatch_get_main_queue()) {
            
            
            
            if state == MCSessionState.Connected {
                
                self.statusLabel.text = "Status: Connected"
                self.playButton.enabled = true
                
     
    
                self.performSegueWithIdentifier("playTheGame", sender: self)
                
                if self.navigationController?.topViewController == self.browser {
                    
                        self.performSegueWithIdentifier("playTheGame", sender: self)

                }
                

                
                
                
            } else if state == MCSessionState.Connecting {
                
                self.statusLabel.text = "Status: Connecting"
                
            } else if state == MCSessionState.NotConnected {
                
                self.statusLabel.text = "Status: Not connected"
                self.playButton.enabled = false
            }
        }
    }
    
    // Received data from remote peer.
    
    func session(session: MCSession, didReceiveData data: NSData, fromPeer peerID: MCPeerID) {
        
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