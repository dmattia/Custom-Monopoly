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
    var image1 : String?
    var image2 : String?
    var image1_name : String?
    var image2_name : String?
    var price1 : Int = 0
    var price2 : Int = 0
    var property_indexes_1 = [Int]()
    var property_indexes_2 = [Int]()
    
    var topView = UIImageView()
    var bottomView = UIImageView()
    var navBuffer = UIView()
    var topTextField : TextField?
    var bottomTextField : TextField?
    var topClicked = false
    var bottomClicked = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let saveButton : UIBarButtonItem = UIBarButtonItem(title: "Save", style: UIBarButtonItemStyle.Plain, target: self, action: "SaveData")
        self.navigationItem.rightBarButtonItem = saveButton
        
        navBuffer.grid.rows = 1
        topView.grid.rows = 3
        bottomView.grid.rows = 3
        view.grid.axis.direction = .Vertical
        
        topView.backgroundColor = MaterialColor.blue.base
        bottomView.backgroundColor = MaterialColor.blue.base
        
        topView.image = UIImage(named: image1!)
        bottomView.image = UIImage(named: image2!)
        
        topView.contentMode = .ScaleAspectFit
        bottomView.contentMode = .ScaleAspectFit
        
        topTextField = createTextView(self.image1_name!)
        bottomTextField = createTextView(self.image2_name!)
        
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
        
        let topImage = topView.image
        let bottomImage = bottomView.image
        
        let chance_spot : [String : AnyObject] = [
            "name": self.topTextField!.text!,
            "price": self.price1,
            "image": self.boardName! + "/" + self.topTextField!.text!
        ]
        let community_chest_spot : [String : AnyObject] = [
            "name": self.bottomTextField!.text!,
            "price": self.price2,
            "image": self.boardName! + "/" + self.bottomTextField!.text!
        ]
        
        // Todo: Ensure this isn't overwriting data
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
        
        let topData = UIImageJPEGRepresentation(topImage!, 0.5)
        let bottomData = UIImageJPEGRepresentation(bottomImage!, 0.5)
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
    }
}