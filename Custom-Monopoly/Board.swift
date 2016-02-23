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
    
    func getBoardLength() -> Int {
        return board.count
    }
}