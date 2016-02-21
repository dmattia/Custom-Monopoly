//
//  ChanceAndCommunityViewController.swift
//  Custom-Monopoly
//
//  Created by David Mattia on 2/20/16.
//  Copyright © 2016 David Mattia. All rights reserved.
//

import UIKit

class ChanceAndCommunityViewController : UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var topView = UIImageView()
    var bottomView = UIImageView()
    var navBuffer = UIView()
    var topTextField : TextField?
    var bottomTextField : TextField?
    var topClicked = false
    var bottomClicked = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBarHidden
        
        navBuffer.grid.rows = 1
        topView.grid.rows = 3
        bottomView.grid.rows = 3
        view.grid.axis.direction = .Vertical
        
        topView.image = UIImage(named: "Chance")
        bottomView.image = UIImage(named: "community 2")
        
        topView.contentMode = .ScaleAspectFit
        bottomView.contentMode = .ScaleAspectFit
        
        topTextField = createTextView("Chance")
        bottomTextField = createTextView("Community Chest")
        

        view.addSubview(topView)
        view.addSubview(topTextField!)
        view.addSubview(bottomView)
        view.addSubview(bottomTextField!)
        
        
        view.grid.views = [navBuffer, navBuffer, topView, topTextField!, navBuffer, bottomView, navBuffer, bottomTextField!]
        
        let tapTop : UIGestureRecognizer = UITapGestureRecognizer(target: self, action: "topImageClicked")
        let tapBottom : UIGestureRecognizer = UITapGestureRecognizer(target: self, action: "bottomImageClicked")

        topView.userInteractionEnabled = true
        bottomView.userInteractionEnabled = true
        topView.addGestureRecognizer(tapTop)
        bottomView.addGestureRecognizer(tapBottom)
    }
    
    func topImageClicked() {
        topClicked = true
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .PhotoLibrary
        
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    func bottomImageClicked() {
        bottomClicked = true
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .PhotoLibrary
        
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    func createTextView(placeholder : String) -> TextField {
        let textField = TextField()
        textField.grid.columns = 12
        textField.grid.rows = 1
        textField.textAlignment = .Center
        
        textField.clearButtonMode = .WhileEditing
        textField.placeholder = placeholder
        textField.font = RobotoFont.regularWithSize(20)
        textField.textColor = MaterialColor.blue.base
        textField.autocorrectionType = .No
        
        textField.titleLabel = UILabel()
        textField.titleLabel!.font = RobotoFont.mediumWithSize(12)
        textField.titleLabelColor = UIColor.clearColor()
        textField.titleLabelActiveColor = MaterialColor.blue.accent3
        return textField
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            topView.contentMode = .ScaleAspectFill
            if topClicked {
                topView.image = pickedImage
                topView.contentMode = .ScaleAspectFit
            } else if bottomClicked {
                bottomView.image = pickedImage
                bottomView.contentMode = .ScaleAspectFit
            }
        }
        topClicked = false
        bottomClicked = false
        dismissViewControllerAnimated(true, completion: nil)
    }
}
