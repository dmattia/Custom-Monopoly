//
//  BoardSpace.swift
//  Custom-Monopoly
//
//  Created by David Mattia on 2/20/16.
//  Copyright © 2016 David Mattia. All rights reserved.
//

import Foundation

protocol BoardSpace {
    var board_index : Int {get}
}

extension BoardSpace {
    func on_land() {}
    func on_leave() {}
}

class Property: BoardSpace {
    var board_index : Int
    
    func on_land() {
        print("landed on space number: \(self.board_index)")
    }
    
    func on_leave() {
        print("leaving space number: \(self.board_index)")
    }
    
    init(index: Int) {
        self.board_index = index
    }
}