//
//  MenuViewController.swift
//  Custom-Monopoly
//
//  Created by David Mattia on 2/20/16.
//  Copyright © 2016 David Mattia. All rights reserved.
//

import UIKit

class MenuViewController : UIViewController {
    var firstSpace : BoardSpace?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func playButtonPressed(sender: AnyObject) {
        firstSpace = myVars.gameBoard.getBoardSpace(0)
        
        if firstSpace is Property {
            self.performSegueWithIdentifier("MenuToProperty", sender: nil)
        } else if firstSpace is Railroad {
            self.performSegueWithIdentifier("MenuToNon", sender: nil)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "MenuToProperty" {
            let destinationVC = segue.destinationViewController as? PropertyViewController
            destinationVC?.property = firstSpace as? Property
            print("Going to property: \(firstSpace)")
        } else if segue.identifier == "MenuToNon" {
            let destinationVC = segue.destinationViewController as? NonPropertyOwnableViewController
            destinationVC?.boardSpace = firstSpace as? Railroad
            print("Going to railroad: \(firstSpace)")
        }
    }
}
