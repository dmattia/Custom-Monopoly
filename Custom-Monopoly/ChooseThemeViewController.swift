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
    private var data : [AnyObject]?
    private var images = [UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
    }
    
    override func viewDidAppear(animated: Bool) {
        let ref = Firebase(url:"https://blistering-fire-9767.firebaseio.com/")
        ref.observeSingleEventOfType(.Value, withBlock: { snapshot in
            self.data = snapshot.children.allObjects
            for var row in 1...self.data!.count {
                self.images.append(UIImage())
            }
            
            for var row in 1...self.data!.count {
                let snap : FDataSnapshot = self.data![row-1] as! FDataSnapshot
                let dict = snap.value as! NSDictionary
                if let imageURL = dict["display_image"] as? String {
                    
                    let downloadingFilePath1 = NSTemporaryDirectory() + "temp-download"
                    let downloadingFileURL1 = NSURL(fileURLWithPath: downloadingFilePath1)
                    let transferManager = AWSS3TransferManager.defaultS3TransferManager()
                    
                    let readRequest1 : AWSS3TransferManagerDownloadRequest = AWSS3TransferManagerDownloadRequest()
                    readRequest1.bucket = "custom-monopoly"
                    readRequest1.key =  imageURL
                    readRequest1.downloadingFileURL = downloadingFileURL1
                    
                    let task = transferManager.download(readRequest1)
                    task.continueWithBlock { (task) -> AnyObject! in
                        if task.error != nil {
                            print(task.error)
                        } else {
                            dispatch_async(dispatch_get_main_queue()
                                , { () -> Void in
                                    //self.images.append(UIImage(contentsOfFile: downloadingFilePath1)!)
                                    self.images[row-1] = UIImage(contentsOfFile: downloadingFilePath1)!
                                    print("Finished image")
                                    self.tableView.reloadData()
                            })
                        }
                        return nil
                    }
                }
            }
            
            self.tableView.reloadData()
        })
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellID = "themeOption"
        var cell = self.tableView.dequeueReusableCellWithIdentifier(cellID) as? PickThemeCell
        
        if (cell == nil) {
            cell = PickThemeCell(style: .Default, reuseIdentifier: cellID)
        }
        
        if let data = data {
            let snap : FDataSnapshot = data[indexPath.row] as! FDataSnapshot
            cell?.themeTitleLabel.text = snap.key
            let image = self.images[indexPath.row]
            cell?.themeImageView.image = image
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
