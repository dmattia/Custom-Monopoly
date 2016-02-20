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
    var detailString : String?
    var shouldDisplayYesButton : Bool?
    var balance : Int = 0
    var cost : Int = 0
    var timer : NSTimer?
    var goalAmount : Int? // The amount left after making a purchase
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let detailString = detailString {
            self.detailLabel?.text = detailString
        }
        
        if let shouldDisplayYesButton = shouldDisplayYesButton {
            self.yesButton.hidden = !shouldDisplayYesButton
            self.yesButton.enabled = shouldDisplayYesButton
        }
        
        self.moneyLabel.text = "You have $\(balance)"
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