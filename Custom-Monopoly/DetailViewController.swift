//
//  DetailViewController.swift
//  Custom-Monopoly
//
//  Created by David Mattia on 2/20/16.
//  Copyright © 2016 David Mattia. All rights reserved.
//

import UIKit

class DetailViewController : UIViewController {
    
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var yesButton: UIButton!
    @IBOutlet weak var moneyLabel: UILabel!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var homeButton: FabButton!
    var detailString : String?
    var shouldDisplayYesButton : Bool?
    var balance : Int = 0
    var cost : Int = 0
    var timer : NSTimer?
    var goalAmount : Int? // The amount left after making a purchase
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.homeButton.backgroundColor = MaterialColor.white
        
        if let detailString = detailString {
            self.detailLabel?.text = detailString
        }
        
        if let shouldDisplayYesButton = shouldDisplayYesButton {
            self.yesButton.hidden = !shouldDisplayYesButton
            self.yesButton.enabled = shouldDisplayYesButton
            if shouldDisplayYesButton {
                self.closeButton.setTitle("No", forState: .Normal)
            }
        }
        
        if balance - cost < 0 {
            self.yesButton.enabled = false
            self.yesButton.backgroundColor = MaterialColor.grey.base
        }
        
        self.moneyLabel.text = "You have $\(balance)"
    }
    
    @IBAction func homeClicked(sender: AnyObject) {
        print("Popping to home view controller")
        
        self.performSegueWithIdentifier("DetailToHome", sender: nil)
    }
    
    @IBAction func yesClicked(sender: AnyObject) {
        goalAmount = balance - cost
        
        self.timer = NSTimer(timeInterval: 0.02, target: self, selector: "updateBalance", userInfo: nil, repeats: true)
        NSRunLoop.currentRunLoop().addTimer(self.timer!, forMode: NSRunLoopCommonModes)
    }
    
    func updateBalance() {
        if balance > goalAmount {
            balance -= 1
            self.moneyLabel.text = "You have $\(balance)"
        } else {
            self.timer!.invalidate()
            myVars.gameplay.getActivePlayer().balance = goalAmount!
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    @IBAction func closeClicked(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
