//
//  ChooseThemeViewController.swift
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

class ChooseThemeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
   
    @IBOutlet weak var tableView: UITableView!
    var data : [AnyObject]?
    var image : UIImage?
    
    func getImageWithUrl(url: String) {
        let downloadingFilePath1 = NSTemporaryDirectory() + "temp-download"
        let downloadingFileURL1 = NSURL(fileURLWithPath: downloadingFilePath1)
        let transferManager = AWSS3TransferManager.defaultS3TransferManager()
        
        let readRequest1 : AWSS3TransferManagerDownloadRequest = AWSS3TransferManagerDownloadRequest()
        readRequest1.bucket = "custom-monopoly"
        readRequest1.key =  url
        readRequest1.downloadingFileURL = downloadingFileURL1
        
        let task = transferManager.download(readRequest1)
        task.continueWithBlock { (task) -> AnyObject! in
            print(task.error)
            if task.error != nil {
            } else {
                dispatch_async(dispatch_get_main_queue()
                    , { () -> Void in
                        self.image = UIImage(contentsOfFile: downloadingFilePath1)
                        //self.selectedImage = UIImage(contentsOfFile: downloadingFilePath1)
                        //self.selectedImage.setNeedsDisplay()
                        //self.selectedImage.reloadInputViews()
                        
                })
                print("Fetched image")
            }
            return nil
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
    }
    
    override func viewDidAppear(animated: Bool) {
        var ref = Firebase(url:"https://blistering-fire-9767.firebaseio.com/")
        ref.observeSingleEventOfType(.Value, withBlock: { snapshot in
            self.data = snapshot.children.allObjects
            self.tableView.reloadData()
        })
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellID = "themeOption"
        let cell = self.tableView.dequeueReusableCellWithIdentifier(cellID)
        
        if (cell == nil) {
            let cell : MaterialTableViewCell = MaterialTableViewCell(style: .Default, reuseIdentifier: cellID)
        }
        
        if let data = data {
            print(data[indexPath.row])
            let snap : FDataSnapshot = data[indexPath.row] as! FDataSnapshot
            cell!.textLabel?.text = snap.key
            
            let dict = snap.value as! NSDictionary
            let imageURL = dict["display_image"] as! String
            
            //getImageWithUrl(imageURL)
            
            let url = imageURL
            
            let downloadingFilePath1 = NSTemporaryDirectory() + "temp-download"
            let downloadingFileURL1 = NSURL(fileURLWithPath: downloadingFilePath1)
            let transferManager = AWSS3TransferManager.defaultS3TransferManager()
            
            let readRequest1 : AWSS3TransferManagerDownloadRequest = AWSS3TransferManagerDownloadRequest()
            readRequest1.bucket = "custom-monopoly"
            readRequest1.key =  url
            readRequest1.downloadingFileURL = downloadingFileURL1
            
            let task = transferManager.download(readRequest1)
            task.continueWithBlock { (task) -> AnyObject! in
                if task.error != nil {
                    print(task.error)
                } else {
                    dispatch_async(dispatch_get_main_queue()
                        , { () -> Void in
                            cell?.imageView?.image = UIImage(contentsOfFile: downloadingFilePath1)
                            cell?.imageView?.setNeedsDisplay()
                            cell?.imageView?.reloadInputViews()
                            
                            print(cell?.imageView?.image)
                    })
                }
                return nil
            }
        }
        
        return cell!
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let data = data {
            return (data.count)
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let optionPressed = indexPath.row
        
        print("Picked theme \(optionPressed)")
        
        self.performSegueWithIdentifier("menuToGo", sender: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "menuToGo" {
            let destinationVC = segue.destinationViewController as? ChanceViewController
            destinationVC?.boardSpace = myVars.gameBoard.getBoardSpace(0) as? MiscSpace

            print("Going to Go")
        }
    }
}
