//
//  Board.swift
//  Custom-Monopoly
//
//  Created by David Mattia on 2/20/16.
//  Copyright © 2016 David Mattia. All rights reserved.
//

import Foundation

struct myVars {
    static var monopoly_board : [BoardSpace] = [
        Property(name: "Ron Weasley", cost: 300),
        Railroad(name: "Platform 9 3/4", cost: 200)
    ]
}

class Board {
    var name : String
    var board : [BoardSpace]
    
    init(name: String) {
        self.name = name
        board = myVars.monopoly_board
    }
    
    func displayBoardSpace(index: Int) {
        let board_space = board[index % board.count]
        if board_space is Property {
            print("Property at index \(index)")
        } else if board_space is Railroad {
            print("Railroad at index \(index)")
        }
    }
}