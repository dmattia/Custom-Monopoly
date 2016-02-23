//
//  BoardSpaceViewController.swift
//  Custom-Monopoly
//
//  Created by David Mattia on 2/22/16.
//  Copyright © 2016 David Mattia. All rights reserved.
//

import UIKit

class BoardSpaceViewController: UIViewController {
    
    var boardSpace : BoardSpace?
    
    @IBOutlet weak var colorView: UIView!
    @IBOutlet weak var costLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var gamePieceImageView: UIImageView!
    @IBOutlet weak var mainImage: UIImageView!
    
    override func canBecomeFirstResponder() -> Bool {
        return true
    }
    
    override func motionEnded(motion: UIEventSubtype, withEvent event: UIEvent?) {
        if motion == .MotionShake && myVars.gameplay.movesLeftInTurn == 0 {
            moveToNextVC()
        }
    }
    
    func display() {
        self.titleLabel.text = boardSpace?.space_name
        self.mainImage.image = boardSpace?.image
        if let ownable = boardSpace as? Ownable {
            self.costLabel.text = "$\(ownable.price)"
        } else if let taxSpace = boardSpace as? TaxSpace {
            self.costLabel.text = "$\(taxSpace.price)"
        } else {
            self.costLabel.text = ""
        }
        if let property = boardSpace as? Property {
            self.colorView.backgroundColor = property.color
        } else {
            self.colorView.backgroundColor = UIColor.clearColor()
        }
    }
    
    func moveToNextVC() {
        // Elevate gamePiece so it does not move with the animation
        let window = UIApplication.sharedApplication().keyWindow
        
        window!.addSubview(self.gamePieceImageView)
        window!.bringSubviewToFront(self.gamePieceImageView)
        window!.makeKeyAndVisible()
        
        // Perform the animation to the next boardSpace
        let nextSpace = myVars.gameBoard.getBoardSpace((boardSpace?.board_index)! + 1)
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let nextVC = storyBoard.instantiateViewControllerWithIdentifier("BoardSpace") as? BoardSpaceViewController
        nextVC!.boardSpace = nextSpace
        
        // TODO: check what this next line does. I forget
        //let navController = UINavigationController(rootViewController: nextVC!)
        let segue = RightToLeftSegue(identifier: "PropertyToProperty", source: self, destination: nextVC!, performHandler: { () -> Void in })
        
        segue.perform()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        display()
        
        let active_player = myVars.gameplay.getActivePlayer()
        let image = UIImage(named: active_player.pictureName)
        self.gamePieceImageView.image = image
        self.view.bringSubviewToFront(self.gamePieceImageView)
        
        gamePieceImageView.layer.borderWidth = 5.0
        gamePieceImageView.layer.masksToBounds = false
        gamePieceImageView.layer.borderColor = UIColor.whiteColor().CGColor
        gamePieceImageView.layer.cornerRadius = gamePieceImageView.frame.width / 2
        gamePieceImageView.clipsToBounds = true
        
        self.navigationController?.navigationBarHidden = true
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if boardSpace?.board_index != 0 {
            self.gamePieceImageView.hidden = true
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        self.gamePieceImageView.hidden = false
        
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
            // Display action for landing
            self.performSegueWithIdentifier("BoardSpaceToDetail", sender: nil)
            
            myVars.gameplay.gameTurn += 1
            myVars.gameplay.hasRolled = false
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "BoardSpaceToDetail" {
            let destinationVC = segue.destinationViewController as? DetailViewController
            if let ownable = boardSpace as? Ownable {
                destinationVC?.detailString = "Do you want to buy \(ownable.space_name) for \(ownable.price)?"
                destinationVC?.shouldDisplayYesButton = true
                destinationVC?.balance = myVars.gameplay.getActivePlayer().balance
                destinationVC?.cost = ownable.price
            } else {
                destinationVC?.detailString = "Some kind of chance card or tax"
                destinationVC?.shouldDisplayYesButton = false
                destinationVC?.balance = myVars.gameplay.getActivePlayer().balance
            }
            // ToDo: Add segue for passing Go
        }
    }
}