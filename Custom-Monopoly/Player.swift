//
//  Player.swift
//  Custom-Monopoly
//
//  Created by David Mattia on 2/20/16.
//  Copyright © 2016 David Mattia. All rights reserved.
//

import UIKit

class Player {
    var balance: Int
    var boardIndex: Int
    var name: String
    var pictureName: String
    var properties: [Ownable]
    var hasPassedGo: Bool // To make sure the user does not get $200 for passing go

    init(name: String, imageName: String) {
        balance = 1500
        boardIndex = 0
        self.name = name
        self.pictureName = imageName
        properties = [Ownable]()
        hasPassedGo = false
    }
}
