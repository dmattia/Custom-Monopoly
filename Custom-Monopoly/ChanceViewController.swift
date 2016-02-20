//
//  ChanceViewController.swift
//  Custom-Monopoly
//
//  Created by David Mattia on 2/20/16.
//  Copyright © 2016 David Mattia. All rights reserved.
//

import UIKit

class ChanceViewController : UIViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var imageLabel: UIImageView!
    @IBOutlet weak var gamePieceImageView: UIImageView!
    
    var boardSpace : MiscSpace?
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
            self.nameLabel.text = boardSpace.space_name
        }
    }
    
    func moveToNextVC() {
        let window = UIApplication.sharedApplication().keyWindow
        
        window!.addSubview(self.gamePieceImageView)
        window!.bringSubviewToFront(self.gamePieceImageView)
        window!.makeKeyAndVisible()

        if nextSpace is MiscSpace {
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let nextVC = storyBoard.instantiateViewControllerWithIdentifier("Chance") as? ChanceViewController
            nextVC!.boardSpace = nextSpace as? MiscSpace
            
            let navController = UINavigationController(rootViewController: nextVC!)
            let segue = RightToLeftSegue(identifier: "ChanceToChance", source: self, destination: nextVC!, performHandler: { () -> Void in})
            segue.perform()
        } else if nextSpace is Property {
            self.performSegueWithIdentifier("ChanceToProperty", sender: nil)
        } else if nextSpace is Railroad {
            self.performSegueWithIdentifier("ChanceToNon", sender: nil)
        } else {
            print("I'm confused man")
        }
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
            boardSpace?.on_leave()
            myVars.gameplay.movesLeftInTurn -= 1
            moveToNextVC()
        } else {
            sleep(5)
            self.boardSpace?.on_land()
            myVars.gameplay.gameTurn += 1
            myVars.gameplay.hasRolled = false
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ChanceToProperty" {
            let destinationVC = segue.destinationViewController as? PropertyViewController
            destinationVC?.property = nextSpace as? Property
        } else if segue.identifier == "ChanceToNon" {
            let destinationVC = segue.destinationViewController as? NonPropertyOwnableViewController
            destinationVC?.boardSpace = nextSpace as? Railroad
        }
    }
}
