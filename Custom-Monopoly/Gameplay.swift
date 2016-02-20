//
//  Gameplay.swift
//  Custom-Monopoly
//
//  Created by David Mattia on 2/20/16.
//  Copyright © 2016 David Mattia. All rights reserved.
//

import UIKit

class Gameplay {
    var players : [Player]
    var board : Board
    var gameTurn : Int
    var hasRolled : Bool
    var movesLeftInTurn : Int
    
    func addPlayer(player: Player) {
        players.append(player)
    }
    
    func getActivePlayer() -> Player {
        // Returns the player who's turn it currently is
        return players[gameTurn % players.count]
    }
    
    init() {
        players = [Player]()
        board = myVars.gameBoard
        gameTurn = 0
        hasRolled = false
        movesLeftInTurn = 0
    }
}