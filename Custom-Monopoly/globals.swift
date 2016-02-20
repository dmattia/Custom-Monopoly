//
//  globals.swift
//  Custom-Monopoly
//
//  Created by David Masttia on 2/20/16.
//  Copyright © 2016 David Mattia. All rights reserved.
//

import UIKit

struct myVars {
    static var monopoly_board : [BoardSpace] = [
        Property(name: "Ron Weasley", cost: 300, index: 0, color: UIColor.redColor()),
        Property(name: "Harry Potter", cost: 400, index: 1, color: UIColor.blueColor()),
        Railroad(name: "Platform 9 3/4", cost: 200, index: 2),
        Property(name: "Harry Potter", cost: 400, index: 3, color: UIColor.blueColor()),
        Railroad(name: "Railroad 2", cost: 200, index: 4),
        Railroad(name: "Railroad 3", cost: 200, index: 5)
    ]
    static var gameBoard = Board(name: "Monopoly Board")
    static var gameplay = Gameplay()
}