//
//  DetailViewController.swift
//  Custom-Monopoly
//
//  Created by David Mattia on 2/20/16.
//  Copyright © 2016 David Mattia. All rights reserved.
//

import UIKit

class DetailViewController : UIViewController {
    
    @IBOutlet weak var detailLabel: UILabel!
    var detailString : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let detailString = detailString {
            self.detailLabel?.text = detailString
        }
    }
    
    @IBAction func closeClicked(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
