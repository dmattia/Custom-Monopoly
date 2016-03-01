//
//  NewNameViewController.swift
//  Custom-Monopoly
//
//  Created by David Mattia on 2/20/16.
//  Copyright © 2016 David Mattia. All rights reserved.
//

import UIKit

class NewNameViewController: UIViewController, UITextFieldDelegate {

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
        self.performSegueWithIdentifier("nameToCreate", sender: nil)
        
        return true
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

    }
}
