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
        let topImageData: NSData = UIImageJPEGRepresentation(topImage!, 0.1)!
        let topImageString: String = topImageData.base64EncodedStringWithOptions(.Encoding64CharacterLineLength)
        
        let bottomImage = bottomView.image
        let bottomImageData: NSData = UIImageJPEGRepresentation(bottomImage!, 0.1)!
        let bottomImageString: String = bottomImageData.base64EncodedStringWithOptions(.Encoding64CharacterLineLength)
        
        
        let chance_spot : [String : AnyObject] = [
            "name": self.topTextField!.text!,
            "price": 0,
            "image": "" //topImageString
        ]
        let community_chest_spot : [String : AnyObject] = [
            "name": self.bottomTextField!.text!,
            "price": 0,
            "image": "" //bottomImageString
        ]
        
        // Todo: Ensure this isn't overwriting data
        let transferManager = AWSS3TransferManager.defaultS3TransferManager()
        var ref = Firebase(url:"https://blistering-fire-9767.firebaseio.com/")
        var boardRef = ref.childByAppendingPath(self.boardName)
        //boardRef.childByAppendingPath("boardName").setValue(self.boardName!)
        //boardRef.childByAppendingPath("main_image").setValue(topImageString)
        boardRef.childByAppendingPath("Property 2").setValue(chance_spot)
        boardRef.childByAppendingPath("Property 7").setValue(community_chest_spot)
        
        // Add images to s3 instance
        let testFileURL1 = NSURL(fileURLWithPath: NSTemporaryDirectory() + "temp")
        let uploadRequest1 : AWSS3TransferManagerUploadRequest = AWSS3TransferManagerUploadRequest()
        
        let data = UIImageJPEGRepresentation(topImage!, 0.5)
        data!.writeToURL(testFileURL1, atomically: true)
        uploadRequest1.bucket = "custom-monopoly"
        uploadRequest1.key =  self.topTextField!.text
        uploadRequest1.body = testFileURL1
        
        let task = transferManager.upload(uploadRequest1)
        task.continueWithBlock { (task) -> AnyObject? in
            if task.error != nil {
                print("Error: \(task.error)")
            } else {
                print("Upload successful")
            }
            return nil
        }
    }
}
