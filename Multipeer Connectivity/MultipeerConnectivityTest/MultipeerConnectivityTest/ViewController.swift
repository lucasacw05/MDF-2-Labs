//
//  ViewController.swift
//  MultipeerConnectivityTest
//
//  Created by Lucas Alencar on 8/13/16.
//  Copyright © 2016 Lucas Alencar. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var chatView: UITextView!
    @IBOutlet weak var inputField: UITextField!
    @IBOutlet weak var navItem: UINavigationItem!
    
    //The Four Main Building Blocks of a Multipeer App
    var peerID: MCPeerID! // Our device's ID or name as viewd by other "browsing" devices.
    var session: MCSession! //The 'connection' between devices
    var browser:MCBrowserViewController! //Prebuilt ViewController that searches for nearby advertisers.
    var advertiser:MCAdvertiserAssistant! // Help us easily advertise ourselves to nearby MCBrowsers
    
    let serviceID = "mdf2-chat" //channel which the communication is going to happen through
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        inputField.delegate = self
        
        //Setup our MC Objects         //This is going to capture the name of the device the user is using
        peerID = MCPeerID(displayName: UIDevice.currentDevice().name)

        //Use peerID to setup a session
        session = MCSession(peer: peerID)
        session.delegate = self
        
        //Setup and start advertising immediately
        advertiser = MCAdvertiserAssistant(serviceType: serviceID, discoveryInfo: nil, session: session)
        advertiser.start()
        
        //Clear out our TextView PLace holder
        chatView.text = nil
        
    }

    @IBAction func connectTapped(sender: AnyObject) {
        
        //Our browser will look for advertisers that share the same service ID
        browser = MCBrowserViewController(serviceType: serviceID, session: session)
        browser.delegate = self
        
        self.presentViewController(browser, animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    @IBAction func sendTapped(sender: AnyObject) {
        //Put  our local text into our own Text View
        
        if let text = inputField.text  {
            chatView.text = "\(chatView.text)\n \(peerID.displayName): \(text)"
            
            //Sending our message
            
            //Encode our string to get an NSData object
            if let encodedString = text.dataUsingEncoding(NSUTF8StringEncoding) {
            
                do {
                    try session.sendData(encodedString, toPeers: session.connectedPeers, withMode: MCSessionSendDataMode.Reliable)
                    print("Sending message: \(text) to \(session.connectedPeers.description)")
                } catch {
                    print(error)
                }
                
                
            }
            
            inputField.text = nil
        }
        
    }
}

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

extension ViewController: MCSessionDelegate {
    
    // Remote peer changed state.
    func session(session: MCSession, peer peerID: MCPeerID, didChangeState state: MCSessionState) {
        
        // This whole callback happens in a background thread.
        // So if you want to update the UI, dispatch to the main queue
        
        dispatch_async(dispatch_get_main_queue()) {
            
            if state == MCSessionState.Connected {
                
                if session.connectedPeers.count > 1 {
                    self.navItem.title = "Status: Connected to \(session.connectedPeers.count) Peers"
                } else {
                    self.navItem.title = "Connected to \(peerID.displayName)"
                }
            }
                
            else if state == MCSessionState.Connecting {
                self.navItem.title = "Status: Connecting"
            }
                
            else if state == MCSessionState.NotConnected {
                self.navItem.title = "Status: No connection"
            }
        }
    }
    
    // Received data from remote peer.
    func session(session: MCSession, didReceiveData data: NSData, fromPeer peerID: MCPeerID) {
        
        //Build new String from the encoded NSData Object. (UnEncoding)
        if let messageText: String = String(data: data, encoding: NSUTF8StringEncoding) {
            
            //UIStuff on Main Thread
            dispatch_async(dispatch_get_main_queue(), { 
                
                self.chatView.text = "\(self.chatView.text)\n \(peerID.displayName): \(messageText)"
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
    func session(session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, atURL localURL: NSURL, withError error: NSError?) {
        
    }
    
}

