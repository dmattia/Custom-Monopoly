//
//  Board.swift
//  Custom-Monopoly
//
//  Created by David Mattia on 2/20/16.
//  Copyright © 2016 David Mattia. All rights reserved.
//

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