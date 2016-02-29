//
//  PreviewViewController.swift
//  Custom-Monopoly
//
//  Created by David Mattia on 2/28/16.
//  Copyright © 2016 David Mattia. All rights reserved.
//

import UIKit

class PreviewViewController: UIViewController {
    var propertyName : String?
    var propertyColor : UIColor = UIColor.clearColor()
    var cost : Int?
    
    @IBOutlet weak var previewName: UITextView!
    @IBOutlet weak var previewCost: UILabel!
    @IBOutlet weak var previewColorView: UIView!
    @IBOutlet weak var previewImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.previewName.text = propertyName ?? "Property Name"
        self.previewColorView.backgroundColor = propertyColor
        if let cost = cost {
            self.previewCost.text = "$\(cost)"
        } else {
            self.previewCost.removeFromSuperview()
        }
    }
    
    @IBAction func saveClicked(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
