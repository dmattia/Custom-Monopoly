//
//  NonPropertyOwnableViewController.swift
//  Custom-Monopoly
//
//  Created by David Mattia on 2/20/16.
//  Copyright © 2016 David Mattia. All rights reserved.
//

import UIKit

class NonPropertyOwnableViewController: UIViewController {
    
    @IBOutlet weak var costLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    var board_index : Int = 4
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let property = myVars.monopoly_board[board_index % myVars.monopoly_board.count] as? Railroad {
            self.costLabel.text = "$\(property.price)"
            self.titleLabel.text = property.space_name
        }
    }
}