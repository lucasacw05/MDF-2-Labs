//
//  ViewController.swift
//  AlencarLucas_CE05
//
//  Created by Lucas Alencar on 8/8/16.
//  Copyright © 2016 Lucas Alencar. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    //Image Outlets
    @IBOutlet weak var image1: UIImageView!
    @IBOutlet weak var image2: UIImageView!
    @IBOutlet weak var image3: UIImageView!
    @IBOutlet weak var image4: UIImageView!
    @IBOutlet weak var image5: UIImageView!
    @IBOutlet weak var image6: UIImageView!
    @IBOutlet weak var image7: UIImageView!
    @IBOutlet weak var image8: UIImageView!
    
    //Serial Queue Creation
    var serialQueue: dispatch_queue_t!
    
    //Concurrent Queue
    var concurrentQueue: dispatch_queue_t!
    
    //Array of URLs, where each item represents a unique image
    var arrayOfImageURLs: [String] = ["https://bit.ly/2aW2tb5", "https://bit.ly/2aIh5em", "https://bit.ly/2aIl7lN", "https://bit.ly/2bavxOY", "https://bit.ly/2baMzvk", "https://bit.ly/2aIl2OT",  "https://bit.ly/2aBMVGJ", "https://bit.ly/2bavzq0"]
    
    
    //ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Giving value to the serial queue
        serialQueue = dispatch_queue_create("someSpecificIdentifierForSerialQueue", DISPATCH_QUEUE_SERIAL)
        
        //Giving value to the concurrent queue
        concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)
        
    }
    
    //Function to clear All Views
    @IBAction func clearAllViews(sender: AnyObject) {
        //Loops through every image and set it to nil
        for image in [image1, image2, image3, image4, image5, image6, image7, image8] {
            image.image = nil
        }
    }
    
    
    //Regular Download
    @IBAction func regularDownload(sender: AnyObject) {
        //Array of Image Outlets
        let arrayOfImages: [UIImageView] = [self.image1, self.image2, self.image3, self.image4, self.image5, self.image6, self.image7, self.image8]
        
        //Uses counter to get the right number of images that are going to be used.
        for j in 0...(arrayOfImages.count - 1) {
            
            //Gets the url
            let imageURL = NSURL(string: arrayOfImageURLs[j])
            //Turns it into an NSData object, a photo
            let imageData = NSData(contentsOfURL: imageURL!)
            
            //Set the images without dispatching it to the main queue
            arrayOfImages[j].image = UIImage(data: imageData!)
        }
    }
    
    
    @IBAction func serialDownload(sender: AnyObject) {
        //Array of Image Outlets
        let arrayOfImages: [UIImageView] = [self.image1, self.image2, self.image3, self.image4, self.image5, self.image6, self.image7, self.image8]
        
        //Uses counter to get the right number of images that are going to be used.
        for j in 0...(arrayOfImages.count - 1) {
            dispatch_async(serialQueue, {
                
                //Gets the url
                let imageURL = NSURL(string: self.arrayOfImageURLs[j])
                //Turns it into an NSData object, a photo
                let imageData = NSData(contentsOfURL: imageURL!)
                
                //Dispatch to the main queue and Update UI
                dispatch_async(dispatch_get_main_queue(), {
                    arrayOfImages[j].image = UIImage(data: imageData!)
                })
            })
        }
    }
    
    
    @IBAction func concurrentDownload(sender: AnyObject) {
        //Array of Image Outlets
        let arrayOfImages: [UIImageView] = [self.image1, self.image2, self.image3, self.image4, self.image5, self.image6, self.image7, self.image8]
        
        //Uses counter to get the right number of images that are going to be used.
        for j in 0...(arrayOfImages.count - 1) {
            
            dispatch_async(concurrentQueue, {
                //Gets the url
                let imageURL = NSURL(string: self.arrayOfImageURLs[j])
                //Turns it into an NSData object, a photo
                let imageData = NSData(contentsOfURL: imageURL!)
                
                //Dispatch to the main queue and Update UI
                dispatch_async(dispatch_get_main_queue(), {
                    arrayOfImages[j].image = UIImage(data: imageData!)
                    
                })
            })
        }
    }
    
}


