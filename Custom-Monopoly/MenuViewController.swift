//
//  MenuViewController.swift
//  Custom-Monopoly
//
//  Created by David Mattia on 2/20/16.
//  Copyright © 2016 David Mattia. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {
    @IBOutlet weak var playerCountLabel: UILabel!
    @IBOutlet weak var stepper: UIStepper!
    var firstSpace: BoardSpace?

    override func viewDidLoad() {
        super.viewDidLoad()

        MyVars.gameBoard.saveToFirebase()

        stepper.minimumValue = 1.00
        stepper.maximumValue = 4.00
        stepper.stepValue = 1.00
        stepper.wraps = true

        // Setup global MyVars
        let player1 = Player(name: "David", imageName: "harry")
        MyVars.gameplay.addPlayer(player1)
    }

    @IBAction func playButtonPressed(sender: AnyObject) {
        print("Launching game with \(MyVars.gameplay.players.count) players")
    }

    @IBAction func stepperPressed(sender: AnyObject) {
        let intValue = Int(self.stepper.value)
        self.playerCountLabel.text = "\(intValue)"
    }
}
