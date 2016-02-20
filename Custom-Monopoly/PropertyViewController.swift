//
//  PropertyViewController.swift
//  Custom-Monopoly
//
//  Created by David Mattia on 2/20/16.
//  Copyright © 2016 David Mattia. All rights reserved.
//

import UIKit

class PropertyViewController: UIViewController {
    
    @IBOutlet weak var costLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    var board_index : Int = 1102
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let property = myVars.monopoly_board[board_index % myVars.monopoly_board.count] as? Property {
            self.costLabel.text = "$\(property.price)"
            self.titleLabel.text = property.space_name
        }
    }
}