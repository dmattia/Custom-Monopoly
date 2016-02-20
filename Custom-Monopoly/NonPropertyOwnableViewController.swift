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
    @IBOutlet weak var gamePieceImageView: UIImageView!
    
    var boardSpace : Railroad?
    var nextSpace : BoardSpace?
    
    override func canBecomeFirstResponder() -> Bool {
        return true
    }
    
    override func motionEnded(motion: UIEventSubtype, withEvent event: UIEvent?) {
        if motion == .MotionShake {
            moveToNextVC()
        }
    }
    
    func display() {
        if let boardSpace = boardSpace {
            self.costLabel.text = "$\(boardSpace.price)"
            self.titleLabel.text = boardSpace.space_name
        }
    }
    
    func moveToNextVC() {
        let window = UIApplication.sharedApplication().keyWindow
        
        window!.addSubview(self.gamePieceImageView)
        window!.bringSubviewToFront(self.gamePieceImageView)
        window!.makeKeyAndVisible()

        if nextSpace is Railroad {
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let nextVC = storyBoard.instantiateViewControllerWithIdentifier("Non") as? NonPropertyOwnableViewController
            nextVC!.boardSpace = nextSpace as? Railroad
            
            let navController = UINavigationController(rootViewController: nextVC!)
            let segue = RightToLeftSegue(identifier: "NonToNon", source: self, destination: nextVC!, performHandler: { () -> Void in})
            segue.perform()
        } else if nextSpace is Property {
            self.performSegueWithIdentifier("NonToProperty", sender: nil)
        } else if nextSpace is MiscSpace {
            self.performSegueWithIdentifier("NonToChance", sender: nil)
        } else {
            print("I'm confused man")
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        gamePieceImageView.hidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nextSpace = myVars.gameBoard.getBoardSpace((self.boardSpace?.board_index)! + 1)
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
            usleep(500000)
            boardSpace?.on_leave()
            myVars.gameplay.movesLeftInTurn -= 1
            moveToNextVC()
        } else {
            self.performSegueWithIdentifier("NonToDetail", sender: nil)
            
            myVars.gameplay.gameTurn += 1
            myVars.gameplay.hasRolled = false
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "NonToProperty" {
            let destinationVC = segue.destinationViewController as? PropertyViewController
            destinationVC?.property = nextSpace as? Property
            print("Going to property: \(nextSpace)")
        } else if segue.identifier == "NonToChance" {
            let destinationVC = segue.destinationViewController as? ChanceViewController
            destinationVC?.boardSpace = nextSpace as? MiscSpace
        } else if segue.identifier == "NonToDetail" {
            let destinationVC = segue.destinationViewController as? DetailViewController
            destinationVC?.detailString = "Do you want to buy \(boardSpace!.space_name) for \(boardSpace!.price)?"
            destinationVC?.shouldDisplayYesButton = true
            destinationVC?.balance = myVars.gameplay.getActivePlayer().balance
            destinationVC?.cost = boardSpace!.price
        }
    }
}