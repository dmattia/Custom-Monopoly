//
//  ChanceAndCommunityViewController.swift
//  Custom-Monopoly
//
//  Created by David Mattia on 2/20/16.
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

class ChanceAndCommunityViewController : UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    // From Segue
    var boardName : String?
    
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
        
        //self.navigationController?.navigationBarHidden = true
        
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
    
    func SaveData() {
        print("Saving Chance and Community Chest")
        
        let topImage = topView.image
        //let topImageData: NSData = UIImageJPEGRepresentation(topImage!, 0.1)!
        //let topImageString: String = topImageData.base64EncodedStringWithOptions(.Encoding64CharacterLineLength)
        
        let bottomImage = bottomView.image
        //let bottomImageData: NSData = UIImageJPEGRepresentation(bottomImage!, 0.1)!
        //let bottomImageString: String = bottomImageData.base64EncodedStringWithOptions(.Encoding64CharacterLineLength)
        
        
        let chance_spot : [String : AnyObject] = [
            "name": self.topTextField!.text!,
            "price": 0,
            "image": self.boardName! + "/" + self.topTextField!.text!
        ]
        let community_chest_spot : [String : AnyObject] = [
            "name": self.bottomTextField!.text!,
            "price": 0,
            "image": self.boardName! + "/" + self.bottomTextField!.text!
        ]
        
        // Todo: Ensure this isn't overwriting data
        let transferManager = AWSS3TransferManager.defaultS3TransferManager()
        let ref = Firebase(url:"https://blistering-fire-9767.firebaseio.com/")
        let boardRef = ref.childByAppendingPath(self.boardName)
        boardRef.childByAppendingPath("display_image").setValue(self.boardName! + "/" + self.topTextField!.text!)
        for index in [2,17,33] {
            boardRef.childByAppendingPath("Property \(index)").setValue(chance_spot)
        }
        for index in [7,22,36] {
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
        
        self.performSegueWithIdentifier("ChanceToBrown", sender: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ChanceToBrown" {
            if let destinationVC = segue.destinationViewController as? TwoPropertyViewController {
                destinationVC.boardName = self.boardName
                /*
                destinationVC.image1 = "house-50"
                destinationVC.image2 = "house-50"
                destinationVC.image1_name = "Mediterranean Avenue"
                destinationVC.image2_name = "Baltic Avenue"
                
                destinationVC.price1 = 60
                destinationVC.price2 = 60
                */
                destinationVC.property_indexes_1 = [1]
                destinationVC.property_indexes_2 = [2]

                destinationVC.topBoardSpace = myVars.gameBoard.getBoardSpace(1)
                destinationVC.topBoardSpace = myVars.gameBoard.getBoardSpace(3)
            } else {
                print("Could not find destination view controller")
            }
        }
    }
}
