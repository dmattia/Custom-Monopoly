//
//  PropertyViewController.swift
//  Custom-Monopoly
//
//  Created by David Mattia on 2/20/16.
//  Copyright © 2016 David Mattia. All rights reserved.
//

import UIKit

class PropertyViewController: UIViewController {
    
    @IBOutlet weak var colorView: UIView!
    @IBOutlet weak var costLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    var property : Property?
    var nextSpace : BoardSpace?
    
    func display() {
        if let property = property {
            self.costLabel.text = "$\(property.price)"
            self.titleLabel.text = property.space_name
            self.colorView.backgroundColor = property.color
        }
    }
    
    func moveToNextVC() {
        if nextSpace is Property {
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let nextVC = storyBoard.instantiateViewControllerWithIdentifier("Property") as? PropertyViewController
            nextVC!.property = nextSpace as? Property
            
            let navController = UINavigationController(rootViewController: nextVC!)
            let segue = RightToLeftSegue(identifier: "PropertyToProperty", source: self, destination: nextVC!, performHandler: { () -> Void in })

            segue.perform()
        } else if nextSpace is Railroad {
            self.performSegueWithIdentifier("PropertyToNon", sender: nil)
        } else {
            print("I'm confused man")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nextSpace = myVars.gameBoard.getBoardSpace((property?.board_index)! + 1)
        display()
        
        self.navigationController?.navigationBarHidden = true
    }
    
    func waitForCompletion(completion: () -> Void) {
            completion()
    }
    
    override func viewDidAppear(animated: Bool) {
        sleep(1)
        moveToNextVC()
    }
    
    @IBAction func nextClicked(sender: AnyObject) {
        moveToNextVC()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "PropertyToNon" {
            let destinationVC = segue.destinationViewController as? NonPropertyOwnableViewController
            destinationVC?.boardSpace = nextSpace as? Railroad
            print("Going to property: \(nextSpace)")
        } else if segue.identifier == "PropertyToChance" {
            /// TODO: DO this
        }
    }
}