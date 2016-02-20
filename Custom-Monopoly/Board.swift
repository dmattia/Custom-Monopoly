//
//  Board.swift
//  Custom-Monopoly
//
//  Created by David Mattia on 2/20/16.
//  Copyright © 2016 David Mattia. All rights reserved.
//

import Foundation

struct myVars {
    static var monopoly_board = [
        Property(index: 1),
        Property(index: 2)
    ]
}

class Board {
    var name : String
    var board : [Property]
    
    init(name: String) {
        self.name = name
        board = myVars.monopoly_board
    }
}