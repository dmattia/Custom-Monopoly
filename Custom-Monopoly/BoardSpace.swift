//
//  BoardSpace.swift
//  Custom-Monopoly
//
//  Created by David Mattia on 2/20/16.
//  Copyright © 2016 David Mattia. All rights reserved.
//

import UIKit

protocol BoardSpace {
    var space_name : String {get}
    var board_index : Int {get}
}

extension BoardSpace {
    func on_land() {
        print("landed on space: \(self.space_name)")
    }
    func on_leave() {
        print("leaving space: \(self.space_name)")
    }
}

protocol Ownable : BoardSpace {
    var space_name : String {get}
    var price : Int {get}
    var owner : Player? {get}
}

extension Ownable {
    func on_buy() {
        print("Bought property: \(self.space_name)")
    }
    func on_mortgage() {
        print("Mortgaged property: \(self.space_name)")
    }
}

class Property: Ownable {
    var board_index : Int
    var space_name : String
    var price : Int
    var color : UIColor
    var owner : Player?
    
    init(name: String, cost: Int, index: Int, color: UIColor) {
        self.space_name = name
        self.price = cost
        self.board_index = index
        self.color = color
        self.owner = nil
    }
}

class Railroad : Ownable {
    var board_index : Int
    var space_name : String
    var price : Int
    var owner : Player?
    
    init(name: String, cost: Int, index: Int) {
        self.space_name = name
        self.price = cost
        self.board_index = index
        self.owner = nil
    }
}

class MiscSpace : BoardSpace {
    // Any chance, comunity chest, or corner spot
    var space_name : String
    var board_index : Int
    
    init(name: String, index: Int) {
        space_name = name
        self.board_index = index
    }
}

