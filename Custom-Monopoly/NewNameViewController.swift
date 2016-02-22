//
//  NewNameViewController.swift
//  Custom-Monopoly
//
//  Created by David Mattia on 2/20/16.
//  Copyright © 2016 David Mattia. All rights reserved.
//

import UIKit

class NewNameViewController : UIViewController, UITextFieldDelegate {
    
    private var boardNameField: TextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        boardNameField = TextField()
        boardNameField.grid.columns = 12
        boardNameField.grid.rows = 1
        boardNameField.textAlignment = .Left
        
        boardNameField.clearButtonMode = .WhileEditing
        boardNameField.placeholder = "Board Name"
        boardNameField.font = RobotoFont.thinWithSize(40)
        boardNameField.textColor = MaterialColor.white
        boardNameField.backgroundColor = MaterialColor.blue.base
        boardNameField.autocorrectionType = .No
        
        boardNameField.titleLabel = UILabel()
        boardNameField.titleLabel!.font = RobotoFont.mediumWithSize(12)
        boardNameField.titleLabelColor = MaterialColor.grey.base
        boardNameField.titleLabelActiveColor = MaterialColor.blue.accent3
        view.addSubview(boardNameField)
        
        boardNameField.delegate = self
        
        view.grid.views = [boardNameField]
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.performSegueWithIdentifier("NameToChance", sender: nil)
        return true
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "NameToChance" {
            let destinationVC = segue.destinationViewController as? ChanceAndCommunityViewController
            destinationVC!.boardName = self.boardNameField.text
            
            if let destinationVC = segue.destinationViewController as? TwoPropertyViewController {
                destinationVC.boardName = self.boardNameField.text
                destinationVC.image1 = "house-50"
                destinationVC.image2 = "house-50"
                destinationVC.image1_name = "Mediterranean Avenue"
                destinationVC.image2_name = "Baltic Avenue"
                
                destinationVC.price1 = 60
                destinationVC.price2 = 60
                destinationVC.property_indexes_1 = [1]
                destinationVC.property_indexes_2 = [2]
            }
        }
    }
}
