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
    private var spaces: [BoardSpace]
    private var name: String
    private var color: UIColor

    init(name: String, spaceIndices: [Int], color: UIColor) {
        self.name = name
        self.spaces = []
        for spaceIndex in spaceIndices {
            self.spaces.append(MyVars.gameBoard.getBoardSpace(spaceIndex))
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

    func getSpaceAtIndex(index: Int) -> BoardSpace {
        return spaces[index]
    }

    func getNameAtIndex(index: Int) -> String {
        return spaces[index].spaceName
    }
}
