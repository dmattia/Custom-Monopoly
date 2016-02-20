//
//  MenuViewController.swift
//  Custom-Monopoly
//
//  Created by David Mattia on 2/20/16.
//  Copyright © 2016 David Mattia. All rights reserved.
//

import UIKit

class MenuViewController : UIViewController {
    @IBOutlet weak var playerCountLabel: UILabel!
    @IBOutlet weak var stepper: UIStepper!
    var firstSpace : BoardSpace?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        stepper.minimumValue = 1.00
        stepper.maximumValue = 4.00
        stepper.stepValue = 1.00
        
        // Setup global myVars
        let player1 = Player(name: "David", imageName: "harry")
        myVars.gameplay.addPlayer(player1)
    }

    @IBAction func playButtonPressed(sender: AnyObject) {
        print("Launching game with \(myVars.gameplay.players.count) players")
        
        firstSpace = myVars.gameBoard.getBoardSpace(0)
        
        if firstSpace is Property {
            self.performSegueWithIdentifier("MenuToProperty", sender: nil)
        } else if firstSpace is Railroad {
            self.performSegueWithIdentifier("MenuToNon", sender: nil)
        } else {
            self.performSegueWithIdentifier("MenuToChance", sender: nil)
        }
    }
    
    @IBAction func stepperPressed(sender: AnyObject) {
        self.playerCountLabel.text = "\(self.stepper.value)"
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
        } else if segue.identifier == "MenuToChance" {
            let destinationVC = segue.destinationViewController as? ChanceViewController
            destinationVC?.boardSpace = firstSpace as? MiscSpace
            print("Going to Go")
        }
    }
}
