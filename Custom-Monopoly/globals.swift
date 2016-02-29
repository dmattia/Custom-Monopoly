//
//  globals.swift
//  Custom-Monopoly
//
//  Created by David Masttia on 2/20/16.
//  Copyright © 2016 David Mattia. All rights reserved.
//

import UIKit

struct myVars {
    static var monopoly_board : [BoardSpace] = [
        MiscSpace(name: "Go", index: 0),
        Property(name: "Borgin and Burkes", cost: 60, index: 1, color: MaterialColor.brown.base),
        MiscSpace(name: "Room of Requirement", index: 2, image_location: "Harry Potter/hogwarts express.jpg"),
        Property(name: "Knockturn Alley", cost: 60, index: 3, color: MaterialColor.brown.base),
        TaxSpace(name: "Ministry of Magic Tax", cost: 200, index: 4),
        Railroad(name: "Hufflepuff", cost: 200, index: 5, image_location: "Harry Potter/goblet_of_fire.jpg"),
        Property(name: "Private Drive", cost: 100, index: 6, color: MaterialColor.blue.lighten2),
        MiscSpace(name: "Goblet of Fire", index: 7),
        Property(name: "The Burrow", cost: 100, index: 8, color: MaterialColor.blue.lighten2),
        Property(name: "Hagrid’s Hut", cost: 120, index: 9, color: MaterialColor.blue.lighten2),
        MiscSpace(name: "Azkaban", index: 10),
        Property(name: "Hog’s Head", cost: 140, index: 11, color: MaterialColor.purple.lighten1),
        Railroad(name: "The Quibbler", cost: 150, index: 12),
        Property(name: "The Leaky Cauldron", cost: 140, index: 13, color: MaterialColor.purple.lighten1),
        Property(name: "Ollivander’s", cost: 160, index: 14, color: MaterialColor.purple.lighten1),
        Railroad(name: "Ravenclaw", cost: 200, index: 15),
        Property(name: "Platform 9 3/4", cost: 180, index: 16, color: MaterialColor.orange.base),
        MiscSpace(name: "Room of Requirement", index: 17),
        Property(name: "Shrieking Shack", cost: 180, index: 18, color: MaterialColor.orange.base),
        Property(name: "Number 12 Grimmauld Place", cost: 200, index: 19, color: MaterialColor.orange.base),
        MiscSpace(name: "Free Flying", index: 20),
        Property(name: "Astronomy Tower", cost: 220, index: 21, color: MaterialColor.red.base),
        MiscSpace(name: "Goblet of Fire", index: 22),
        Property(name: "Forbidden Forest", cost: 220, index: 23, color: MaterialColor.red.base),
        Property(name: "Chamber of Secrets", cost: 240, index: 24, color: MaterialColor.red.base),
        Railroad(name: "Slytherin", cost: 200, index: 25),
        Property(name: "Great Hall", cost: 260, index: 26, color: MaterialColor.yellow.base),
        Property(name: "Quidditch Pitch", cost: 260, index: 27, color: MaterialColor.yellow.base),
        Railroad(name: "The Daily Prophet", cost: 150, index: 28),
        Property(name: "Dumbledore’s Office", cost: 280, index: 29, color: MaterialColor.yellow.base),
        MiscSpace(name: "Go to Azkaban", index: 30),
        Property(name: "Hospital Wing", cost: 300, index: 31, color: MaterialColor.green.base),
        Property(name: "Diagon Alley", cost: 300, index: 32, color: MaterialColor.green.base),
        MiscSpace(name: "Room of Requirement", index: 33),
        Property(name: "Hogsmeade", cost: 320, index: 34, color: MaterialColor.green.base),
        Railroad(name: "Gryffindor", cost: 200, index: 35),
        MiscSpace(name: "Goblet of Fire", index: 36),
        Property(name: "Ministry of Magic", cost: 350, index: 37, color: MaterialColor.blue.darken1),
        TaxSpace(name: "Gringotts Banking Tax", cost: 100, index: 38),
        Property(name: "Hogwarts", cost: 400, index: 39, color: MaterialColor.blue.darken1)
    ]
    static var gameBoard = Board(name: "Monopoly Board")
    static var gameplay = Gameplay()
    
    static var gameSets : [BoardSpaceSet] = [
        BoardSpaceSet(name: "Browns", space_indices: [1, 3]),
        BoardSpaceSet(name: "Light Blues", space_indices: [6, 8, 9])
    ]
}