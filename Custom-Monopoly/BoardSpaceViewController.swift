//
//  BoardSpaceViewController.swift
//  Custom-Monopoly
//
//  Created by David Mattia on 2/22/16.
//  Copyright © 2016 David Mattia. All rights reserved.
//

import UIKit

class BoardSpaceViewController: UIViewController {

    var boardSpace: BoardSpace?

    @IBOutlet weak var colorView: UIView!
    @IBOutlet weak var costLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var gamePieceImageView: UIImageView!
    @IBOutlet weak var mainImage: UIImageView!

    override func canBecomeFirstResponder() -> Bool {
        return true
    }

    override func motionEnded(motion: UIEventSubtype, withEvent event: UIEvent?) {
        if motion == .MotionShake && MyVars.gameplay.movesLeftInTurn == 0 {
            moveToNextVC()
        }
    }

    func display() {
        self.titleLabel.text = boardSpace?.spaceName
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

    func moveToBoardSpace(boardIndex: Int) {
        // Elevate gamePiece so it does not move with the animation
        let window = UIApplication.sharedApplication().keyWindow

        window!.addSubview(self.gamePieceImageView)
        window!.bringSubviewToFront(self.gamePieceImageView)
        window!.makeKeyAndVisible()

        // Perform the animation to the next boardSpace
        let nextSpace = MyVars.gameBoard.getBoardSpace(boardIndex)

        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let nextVC = storyBoard.instantiateViewControllerWithIdentifier("BoardSpace")
            as? BoardSpaceViewController
        nextVC!.boardSpace = nextSpace

        let segue = RightToLeftSegue(identifier: "PropertyToProperty",
            source: self,
            destination: nextVC!,
            performHandler: { () -> Void in })

        segue.perform()
    }

    func moveToNextVC() {
        moveToBoardSpace((self.boardSpace?.boardIndex)! + 1)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        display()

        let active_player = MyVars.gameplay.getActivePlayer()
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

        if boardSpace?.boardIndex != 0 {
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

        if !MyVars.gameplay.hasRolled {
            MyVars.gameplay.newTurn()
        }

        if MyVars.gameplay.movesLeftInTurn > 0 {
            usleep(500000)
            boardSpace?.on_leave()
            MyVars.gameplay.movesLeftInTurn -= 1
            moveToNextVC()
        } else {
            // Display action for landing
            self.performSegueWithIdentifier("BoardSpaceToDetail", sender: nil)

            MyVars.gameplay.gameTurn += 1
            MyVars.gameplay.hasRolled = false
        }
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "BoardSpaceToDetail" {
            let destinationVC = segue.destinationViewController as? DetailViewController
            if let ownable = boardSpace as? Ownable {
                destinationVC?.detailString =
                    "Do you want to buy \(ownable.spaceName) for \(ownable.price)?"
                destinationVC?.shouldDisplayYesButton = true
                destinationVC?.balance = MyVars.gameplay.getActivePlayer().balance
                destinationVC?.cost = ownable.price
            } else {
                destinationVC?.detailString = "Some kind of chance card or tax"
                destinationVC?.shouldDisplayYesButton = false
                destinationVC?.balance = MyVars.gameplay.getActivePlayer().balance
            }
            // ToDo: Add segue for passing Go
        }
    }
}
