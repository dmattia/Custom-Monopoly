//
//  TwoPropertyViewController.swift
//  Custom-Monopoly
//
//  Created by David Mattia on 2/21/16.
//  Copyright © 2016 David Mattia. All rights reserved.
//

import UIKit
import Firebase
import AWSCore
import AWSCognito
import AWSS3
import AWSDynamoDB
import AWSSQS
import AWSSNS

class TwoPropertyViewController : UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // From Segue
    var boardName : String?
    var property_indexes_1 = [Int]()
    var property_indexes_2 = [Int]()
    var topBoardSpace : BoardSpace?
    var bottomBoardSpace : BoardSpace?
    
    var topView = UIImageView()
    var bottomView = UIImageView()
    var topTextField : TextField?
    var bottomTextField : TextField?
    
    // Controlls to determine which picture gets updated
    var topClicked = false
    var bottomClicked = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let saveButton : UIBarButtonItem = UIBarButtonItem(title: "Save", style: UIBarButtonItemStyle.Plain, target: self, action: "SaveData")
        self.navigationItem.rightBarButtonItem = saveButton
        
        let navBuffer = UIView()
        navBuffer.grid.rows = 1
        topView.grid.rows = 3
        bottomView.grid.rows = 3
        view.grid.axis.direction = .Vertical
        
        topView.backgroundColor = MaterialColor.blue.base
        bottomView.backgroundColor = MaterialColor.blue.base
        
        topView.contentMode = .ScaleAspectFit
        bottomView.contentMode = .ScaleAspectFit
        
        if let top = self.topBoardSpace {
            self.topTextField = createTextView(top.space_name)
        }
        if let bottom = self.bottomBoardSpace {
            self.bottomTextField = createTextView(bottom.space_name)
        }
        
        view.addSubview(topView)
        view.addSubview(topTextField!)
        view.addSubview(bottomView)
        view.addSubview(bottomTextField!)
        
        view.grid.views = [navBuffer, navBuffer, topView, topTextField!, navBuffer, bottomView, bottomTextField!, navBuffer]
        
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
    
    // Creates a textfield with @initial_text as the initial text value
    func createTextView(placeholder : String) -> TextField {
        let textField = TextField()
        textField.grid.columns = 12
        textField.grid.rows = 1
        textField.textAlignment = .Center
        
        textField.clearButtonMode = .WhileEditing
        textField.placeholder = placeholder
        textField.text = placeholder
        textField.font = RobotoFont.regularWithSize(20)
        textField.textColor = MaterialColor.blue.base
        textField.autocorrectionType = .No
        
        textField.titleLabel = UILabel()
        textField.titleLabel!.font = RobotoFont.mediumWithSize(12)
        textField.titleLabelColor = UIColor.clearColor()
        textField.titleLabelActiveColor = MaterialColor.black
        return textField
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            if topClicked {
                topView.image = pickedImage
                topView.contentMode = .ScaleAspectFit
                topView.backgroundColor = UIColor.clearColor()
            } else if bottomClicked {
                bottomView.image = pickedImage
                bottomView.contentMode = .ScaleAspectFit
                bottomView.backgroundColor = UIColor.clearColor()
            }
        }
        topClicked = false
        bottomClicked = false
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func SaveData() {
        print("Saving Chance and Community Chest")
        
        if let topImage = topView.image,
            bottomImage = bottomView.image {
        
                var price1 = 0
                if self.topBoardSpace is Ownable {
                    price1 = (self.topBoardSpace as! Ownable).price
                }
                
                var price2 = 0
                if self.bottomBoardSpace is Ownable {
                    price2 = (self.bottomBoardSpace as! Ownable).price
                }
                
                let chance_spot : [String : AnyObject] = [
                    "name": self.topTextField!.text!,
                    "price": price1,
                    "image": self.boardName! + "/" + self.topTextField!.text!
                ]
                let community_chest_spot : [String : AnyObject] = [
                    "name": self.bottomTextField!.text!,
                    "price": price2,
                    "image": self.boardName! + "/" + self.bottomTextField!.text!
                ]
                
                let transferManager = AWSS3TransferManager.defaultS3TransferManager()
                let ref = Firebase(url:"https://blistering-fire-9767.firebaseio.com/")
                let boardRef = ref.childByAppendingPath(self.boardName)
                boardRef.childByAppendingPath("display_image").setValue(self.boardName! + "/" + self.topTextField!.text!)
                for index in property_indexes_1 {
                    boardRef.childByAppendingPath("Property \(index)").setValue(chance_spot)
                }
                for index in property_indexes_2 {
                    boardRef.childByAppendingPath("Property \(index)").setValue(community_chest_spot)
                }
                
                // Add images to s3 instance
                let topFileURL1 = NSURL(fileURLWithPath: NSTemporaryDirectory() + "temp")
                let bottomFileURL2 = NSURL(fileURLWithPath: NSTemporaryDirectory() + "temp")
                let uploadRequest1 : AWSS3TransferManagerUploadRequest = AWSS3TransferManagerUploadRequest()
                let uploadRequest2 : AWSS3TransferManagerUploadRequest = AWSS3TransferManagerUploadRequest()
                
                let topData = UIImageJPEGRepresentation(topImage, 0.5)
                let bottomData = UIImageJPEGRepresentation(bottomImage, 0.5)
                topData!.writeToURL(topFileURL1, atomically: true)
                bottomData!.writeToURL(bottomFileURL2, atomically: true)
                
                uploadRequest1.bucket = "custom-monopoly"
                uploadRequest1.key =  self.boardName! + "/" + self.topTextField!.text!
                uploadRequest1.body = topFileURL1
                uploadRequest1.ACL = AWSS3ObjectCannedACL.PublicRead
                
                uploadRequest2.bucket = "custom-monopoly"
                uploadRequest2.key =  self.boardName! + "/" + self.bottomTextField!.text!
                uploadRequest2.body = bottomFileURL2
                uploadRequest2.ACL = AWSS3ObjectCannedACL.PublicRead
                
                var task = transferManager.upload(uploadRequest1)
                task.continueWithBlock { (task) -> AnyObject? in
                    if task.error != nil {
                        print("Error: \(task.error)")
                    } else {
                        print("Upload top successful")
                    }
                    return nil
                }
                
                task = transferManager.upload(uploadRequest2)
                task.continueWithBlock { (task) -> AnyObject? in
                    if task.error != nil {
                        print("Error: \(task.error)")
                    } else {
                        print("Upload bottom successful")
                    }
                    return nil
                }
            } else {
                // At least one image is null
                let cardView: CardView = CardView()
                
                // Title label.
                let titleLabel: UILabel = UILabel()
                titleLabel.text = "Error Saving Images"
                titleLabel.textColor = MaterialColor.blue.darken1
                titleLabel.font = RobotoFont.mediumWithSize(20)
                cardView.titleLabel = titleLabel
                
                // Detail label.
                let detailLabel: UILabel = UILabel()
                detailLabel.text = "Please make sure that you have selected an image for both the top and bottom cards"
                detailLabel.numberOfLines = 0
                cardView.detailView = detailLabel
                
                // Yes button.
                let btn1: FlatButton = FlatButton()
                btn1.pulseColor = MaterialColor.blue.lighten1
                //btn1.pulseFill = true
                btn1.pulseScale = false
                btn1.setTitle("Will Do", forState: .Normal)
                btn1.setTitleColor(MaterialColor.blue.darken1, forState: .Normal)
                
                // Add buttons to left side.
                cardView.leftButtons = [btn1]
                
                // To support orientation changes, use MaterialLayout.
                view.addSubview(cardView)
                cardView.translatesAutoresizingMaskIntoConstraints = false
                MaterialLayout.alignFromTop(view, child: cardView, top: 200)
                MaterialLayout.alignToParentHorizontally(view, child: cardView, left: 20, right: 20)
            }
    }
}