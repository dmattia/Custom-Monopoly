//
//  Board.swift
//  Custom-Monopoly
//
//  Created by David Mattia on 2/20/16.
//  Copyright © 2016 David Mattia. All rights reserved.
//

import UIKit

struct myVars {
    static var monopoly_board : [BoardSpace] = [
        Property(name: "Ron Weasley", cost: 300, index: 0, color: UIColor.redColor()),
        Property(name: "Harry Potter", cost: 400, index: 1, color: UIColor.blueColor()),
        //Railroad(name: "Platform 9 3/4", cost: 200, index: 2),
        //Railroad(name: "Railroad 2", cost: 200, index: 3)
    ]
    static var gameBoard = Board(name: "Monopoly Board")
}

class Board {
    var name : String
    var board : [BoardSpace]
    
    init(name: String) {
        self.name = name
        board = myVars.monopoly_board
    }
    
    func getBoardSpace(index: Int) -> BoardSpace {
        return board[index % board.count]
    }
    
    func displayBoardSpace(index: Int) {
        let board_space = board[index % board.count]
        if board_space is Property {
            print("Property at index \(index)")
            let vc = PropertyViewController()
            vc.property = board_space as? Property
            vc.display()
        } else if board_space is Railroad {
            print("Railroad at index \(index)")
            let vc = NonPropertyOwnableViewController()
            vc.boardSpace = board_space as? Railroad
            vc.display()
        }
    }
}