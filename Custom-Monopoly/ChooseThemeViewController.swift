//
//  ChooseThemeViewController.swift
//  Custom-Monopoly
//
//  Created by David Mattia on 2/21/16.
//  Copyright © 2016 David Mattia. All rights reserved.
//

import UIKit
import Firebase

class ChooseThemeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
   
    @IBOutlet weak var tableView: UITableView!
    var data : [AnyObject]?
    
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
            
            //let dict = snap.value as! NSDictionary
            //cell!.textLabel?.text = dict["boardName"] as! String
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
