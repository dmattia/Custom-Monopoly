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
        Property(name: "Borgin and Burkes", cost: 60, index: 1, color: UIColor.purpleColor()),
        MiscSpace(name: "Room of Requirement", index: 2),
        Property(name: "Knockturn Alley", cost: 60, index: 3, color: UIColor.purpleColor()),
        Railroad(name: "Ministry of Magic Tax", cost: 200, index: 4),
        Railroad(name: "Hufflepuff", cost: 200, index: 5),
        Property(name: "Private Drive", cost: 100, index: 6, color: UIColor.lightGrayColor()),
        MiscSpace(name: "Goblet of Fire", index: 7),
        Property(name: "The Burrow", cost: 100, index: 8, color: UIColor.lightGrayColor()),
        Property(name: "Hagrid’s Hut", cost: 120, index: 9, color: UIColor.lightGrayColor()),
        MiscSpace(name: "Azkaban", index: 10),
        Property(name: "Hog’s Head", cost: 140, index: 11, color: UIColor.magentaColor()),
        Railroad(name: "The Quibbler", cost: 150, index: 12),
        Property(name: "The Leaky Cauldron", cost: 140, index: 13, color: UIColor.magentaColor()),
        Property(name: "Ollivander’s", cost: 160, index: 14, color: UIColor.magentaColor()),
        Railroad(name: "Ravenclaw", cost: 200, index: 15),
        Property(name: "Platform 9 3/4", cost: 180, index: 16, color: UIColor.orangeColor()),
        MiscSpace(name: "Room of Requirement", index: 17),
        Property(name: "Shrieking Shack", cost: 180, index: 18, color: UIColor.orangeColor()),
        Property(name: "Number 12 Grimmauld Place", cost: 200, index: 19, color: UIColor.orangeColor()),
        MiscSpace(name: "Free Flying", index: 20),
        Property(name: "Astronomy Tower", cost: 220, index: 21, color: UIColor.redColor()),
        MiscSpace(name: "Goblet of Fire", index: 22),
        Property(name: "Forbidden Forest", cost: 220, index: 23, color: UIColor.redColor()),
        Property(name: "Chamber of Secrets", cost: 240, index: 24, color: UIColor.redColor()),
        Railroad(name: "Slytherin", cost: 200, index: 25),
        Property(name: "Great Hall", cost: 260, index: 26, color: UIColor.yellowColor()),
        Property(name: "Quidditch Pitch", cost: 260, index: 27, color: UIColor.yellowColor()),
        Railroad(name: "The Daily Prophet", cost: 150, index: 28),
        Property(name: "Dumbledore’s Office", cost: 280, index: 29, color: UIColor.yellowColor()),
        MiscSpace(name: "Go to Azkaban", index: 30),
        Property(name: "St. Mungo’s", cost: 300, index: 31, color: UIColor.greenColor()),
        Property(name: "Diagon Alley", cost: 300, index: 32, color: UIColor.greenColor()),
        MiscSpace(name: "Room of Requirement", index: 33),
        Property(name: "Hogshead", cost: 320, index: 34, color: UIColor.greenColor()),
        Railroad(name: "Gryffindor", cost: 200, index: 35),
        MiscSpace(name: "Goblet of Fire", index: 36),
        Property(name: "Ministry of Magic", cost: 350, index: 37, color: UIColor.blueColor()),
        Railroad(name: "Gringotts Banking Tax", cost: 100, index: 38),
        Property(name: "Hogwarts", cost: 400, index: 39, color: UIColor.blueColor())
    ]
    static var gameBoard = Board(name: "Monopoly Board")
    static var gameplay = Gameplay()
}