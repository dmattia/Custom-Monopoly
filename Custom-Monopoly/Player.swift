//
//  Player.swift
//  Custom-Monopoly
//
//  Created by David Mattia on 2/20/16.
//  Copyright © 2016 David Mattia. All rights reserved.
//

import UIKit

class Player {
    var balance : Int
    var board_index : Int
    var name : String
    var pictureName: String
    var properties : [Ownable]
    
    init(name: String, imageName: String) {
        balance = 1500
        board_index = 0
        self.name = name
        self.pictureName = imageName
        properties = [Ownable]()
    }
}