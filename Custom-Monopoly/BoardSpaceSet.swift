//
//  BoardSpaceSet.swift
//  Custom-Monopoly
//
//  Created by David Mattia on 2/28/16.
//  Copyright © 2016 David Mattia. All rights reserved.
//

import UIKit

// A set of board spaces. ie) A single color triplet

class BoardSpaceSet {
    private var spaces : [BoardSpace]
    private var name : String
    private var color : UIColor
    
    init(name : String, space_indices : [Int], color : UIColor) {
        self.name = name
        self.spaces = []
        for space_index in space_indices {
            self.spaces.append(myVars.gameBoard.getBoardSpace(space_index))
        }
        self.color = color
    }

    func getSpaces() -> [BoardSpace] {
        return spaces
    }
    
    func getColor() -> UIColor {
        return self.color
    }
    
    func getName() -> String {
        return self.name
    }
    
    func getNumberOfSpacesInSet() -> Int {
        return spaces.count
    }
    
    func getNameAtIndex(index: Int) -> String {
        return spaces[index].space_name
    }    
}
