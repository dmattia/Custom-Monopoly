//
//  BoardSpace.swift
//  Custom-Monopoly
//
//  Created by David Mattia on 2/20/16.
//  Copyright © 2016 David Mattia. All rights reserved.
//

import Foundation

protocol BoardSpace {
    var space_name : String {get}
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
    var space_name : String
    var price : Int
    
    init(name: String, cost: Int) {
        self.space_name = name
        self.price = cost
    }
}

class Railroad : Ownable {
    var space_name : String
    var price : Int
    
    init(name: String, cost: Int) {
        self.space_name = name
        self.price = cost
    }
}