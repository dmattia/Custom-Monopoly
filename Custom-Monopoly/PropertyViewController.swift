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
    @IBOutlet weak var gamePieceImageView: UIImageView!
    
    override func canBecomeFirstResponder() -> Bool {
        return true
    }
    
    override func motionEnded(motion: UIEventSubtype, withEvent event: UIEvent?) {
        if motion == .MotionShake {
            moveToNextVC()
        }
    }
    
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
        let window = UIApplication.sharedApplication().keyWindow
        
        window!.addSubview(self.gamePieceImageView)
        window!.bringSubviewToFront(self.gamePieceImageView)
        window!.makeKeyAndVisible()
                
        if nextSpace is Property {
            self.gamePieceImageView.hidden = true
            
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let nextVC = storyBoard.instantiateViewControllerWithIdentifier("Property") as? PropertyViewController
            nextVC!.property = nextSpace as? Property
            
            let navController = UINavigationController(rootViewController: nextVC!)
            let segue = RightToLeftSegue(identifier: "PropertyToProperty", source: self, destination: nextVC!, performHandler: { () -> Void in })

            segue.perform()
        } else if nextSpace is Railroad {
            self.performSegueWithIdentifier("PropertyToNon", sender: nil)
        } else if nextSpace is MiscSpace {
            self.performSegueWithIdentifier("PropertyToChance", sender: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nextSpace = myVars.gameBoard.getBoardSpace((property?.board_index)! + 1)
        display()
        
        let active_player = myVars.gameplay.getActivePlayer()
        let image = UIImage(named: active_player.pictureName)
        self.gamePieceImageView.image = image
        
        gamePieceImageView.layer.borderWidth = 5.0
        gamePieceImageView.layer.masksToBounds = false
        gamePieceImageView.layer.borderColor = UIColor.whiteColor().CGColor
        gamePieceImageView.layer.cornerRadius = gamePieceImageView.frame.width / 2
        gamePieceImageView.clipsToBounds = true
        
        self.navigationController?.navigationBarHidden = true
    }
    
    override func viewWillAppear(animated: Bool) {
        gamePieceImageView.hidden = true
    }
    
    override func viewDidAppear(animated: Bool) {
        gamePieceImageView.hidden = false
        
        let window = UIApplication.sharedApplication().keyWindow
        
        window!.addSubview(self.gamePieceImageView)
        window!.sendSubviewToBack(self.gamePieceImageView)
        window!.makeKeyAndVisible()
        
        if !myVars.gameplay.hasRolled {
            myVars.gameplay.newTurn()
        }
        
        if myVars.gameplay.movesLeftInTurn > 0 {
            sleep(1)
            property?.on_leave()
            myVars.gameplay.movesLeftInTurn -= 1
            moveToNextVC()
        } else {
            // Display action for landing
            self.performSegueWithIdentifier("PropertyToDetail", sender: nil)
            
            myVars.gameplay.gameTurn += 1
            myVars.gameplay.hasRolled = false
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "PropertyToNon" {
            let destinationVC = segue.destinationViewController as? NonPropertyOwnableViewController
            destinationVC?.boardSpace = nextSpace as? Railroad
            print("Going to property: \(nextSpace)")
        } else if segue.identifier == "PropertyToChance" {
            let destinationVC = segue.destinationViewController as? ChanceViewController
            destinationVC?.boardSpace = nextSpace as? MiscSpace
        } else if segue.identifier == "PropertyToDetail" {
            let destinationVC = segue.destinationViewController as? DetailViewController
            destinationVC?.detailString = "Do you want to buy \(property!.space_name)"
        }
    }
}