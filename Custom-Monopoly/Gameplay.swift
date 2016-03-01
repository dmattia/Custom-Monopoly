//
//  Gameplay.swift
//  Custom-Monopoly
//
//  Created by David Mattia on 2/20/16.
//  Copyright © 2016 David Mattia. All rights reserved.
//

import UIKit

class Gameplay {
    var players: [Player]
    var board: Board
    var gameTurn: Int
    var hasRolled: Bool
    var movesLeftInTurn: Int

    func addPlayer(player: Player) {
        players.append(player)
    }

    func getActivePlayer() -> Player {
        // Returns the player who's turn it currently is
        return players[gameTurn % players.count]
    }

    func newTurn() {
        srandom(2)
        self.hasRolled = true

        // Simulate a dice roll
        let randomValue = random() % 36 + 1
        if randomValue <= 1 {
            self.movesLeftInTurn = 2
        } else if randomValue <= 3 {
            self.movesLeftInTurn = 3
        } else if randomValue <= 6 {
            self.movesLeftInTurn = 4
        } else if randomValue <= 10 {
            self.movesLeftInTurn = 5
        } else if randomValue <= 15 {
            self.movesLeftInTurn = 6
        } else if randomValue <= 21 {
            self.movesLeftInTurn = 7
        } else if randomValue <= 26 {
            self.movesLeftInTurn = 8
        } else if randomValue <= 30 {
            self.movesLeftInTurn = 9
        } else if randomValue <= 33 {
            self.movesLeftInTurn = 10
        } else if randomValue <= 35 {
            self.movesLeftInTurn = 11
        } else {
            self.movesLeftInTurn = 12
        }
    }

    init() {
        players = [Player]()
        board = MyVars.gameBoard
        gameTurn = 0
        hasRolled = false
        movesLeftInTurn = 0
    }
}
