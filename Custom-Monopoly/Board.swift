//
//  Board.swift
//  Custom-Monopoly
//
//  Created by David Mattia on 2/20/16.
//  Copyright © 2016 David Mattia. All rights reserved.
//

import Firebase
import AWSCore
import AWSCognito
import AWSS3
import AWSDynamoDB
import AWSSQS
import AWSSNS

class Board {
    var name : String
    var board : [BoardSpace]
    
    init(name: String) {
        self.name = name
        self.board = myVars.monopoly_board
    }
    
    func getBoardSpace(index: Int) -> BoardSpace {
        return board[index % board.count]
    }
    
    func getBoardLength() -> Int {
        return board.count
    }
    
    // Saves @board into a Firebase Database
    func saveToFirebase() {
        let ref = Firebase(url:"https://blistering-fire-9767.firebaseio.com/")
        let boardRef = ref.childByAppendingPath(self.name)
        
        for space_index in 0...board.count-1 {
            let space = board[space_index]
            let json : [String : AnyObject] = [
                "name": space.space_name,
                "price": (space as? Ownable)?.price ?? 0,
                "image": space.image_location
            ]
            boardRef.childByAppendingPath("Property \(space_index)").setValue(json)
        }
    }
}