//
//  DownloadingImagesViewController.swift
//  Custom-Monopoly
//
//  Created by David Mattia on 2/22/16.
//  Copyright © 2016 David Mattia. All rights reserved.
//

import UIKit

class DownloadingImagesViewController : UIViewController {
    
    @IBOutlet weak var progressView: UIProgressView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.progressView.setProgress(0.0, animated: false)
        
        dispatch_async(dispatch_get_main_queue()) {
            for var space in myVars.monopoly_board {
                let task : AWSTask = space.dowload_image()
                
                task.continueWithBlock { (task) -> AnyObject! in
                    if task.error != nil {
                        print(task.error)
                    } else {
                        dispatch_async(dispatch_get_main_queue()
                            , { () -> Void in
                                self.progressView.setProgress(self.progressView.progress + 1.0 / Float(myVars.monopoly_board.count), animated: true)
                                print("Finished downloading image: \(space.board_index)")
                                print("Progress is now: \(self.progressView.progress)")
                                if self.progressView.progress > 0.99 {
                                    print("Taking segue")
                                    self.performSegueWithIdentifier("DownloadingToBoard", sender: nil)
                                }
                        })
                    }
                    return nil
                }
            }
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "DownloadingToBoard",
            let destinationVC = segue.destinationViewController as? BoardSpaceViewController {
                destinationVC.boardSpace = myVars.gameBoard.getBoardSpace(0)
        }
    }
}
