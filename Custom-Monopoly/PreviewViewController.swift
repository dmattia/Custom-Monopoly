//
//  PreviewViewController.swift
//  Custom-Monopoly
//
//  Created by David Mattia on 2/28/16.
//  Copyright © 2016 David Mattia. All rights reserved.
//

import UIKit

class PreviewViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func saveClicked(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
