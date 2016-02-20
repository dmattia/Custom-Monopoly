//
//  NonPropertyOwnableViewController.swift
//  Custom-Monopoly
//
//  Created by David Mattia on 2/20/16.
//  Copyright © 2016 David Mattia. All rights reserved.
//

import UIKit

class NonPropertyOwnableViewController: UIViewController {
    
    @IBOutlet weak var costLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    var boardSpace : Railroad?
    var nextSpace : BoardSpace?
    
    func display() {
        if let boardSpace = boardSpace {
            self.costLabel.text = "$\(boardSpace.price)"
            self.titleLabel.text = boardSpace.space_name
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nextSpace = myVars.gameBoard.getBoardSpace((self.boardSpace?.board_index)! + 1)
        display()
        
        self.navigationController?.navigationBarHidden = true
    }
    
    @IBAction func nextClicked(sender: AnyObject) {
        if nextSpace is Railroad {
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let nextVC = storyBoard.instantiateViewControllerWithIdentifier("Non") as? NonPropertyOwnableViewController
            nextVC!.boardSpace = nextSpace as? Railroad
            
            let navController = UINavigationController(rootViewController: nextVC!)
            let segue = RightToLeftSegue(identifier: "NonToNon", source: self, destination: nextVC!, performHandler: { () -> Void in})
            segue.perform()
        } else if nextSpace is Property {
            self.performSegueWithIdentifier("NonToProperty", sender: nil)
        } else {
            print("I'm confused man")
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "NonToProperty" {
            let destinationVC = segue.destinationViewController as? PropertyViewController
            destinationVC?.property = nextSpace as? Property
            print("Going to property: \(nextSpace)")
        } else if segue.identifier == "NonToChance" {
            /// TODO: DO this
        }
    }
}