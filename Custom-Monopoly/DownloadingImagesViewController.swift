//
//  DownloadingImagesViewController.swift
//  Custom-Monopoly
//
//  Created by David Mattia on 2/22/16.
//  Copyright © 2016 David Mattia. All rights reserved.
//

import UIKit

class DownloadingImagesViewController: UIViewController {

    @IBOutlet weak var progressView: UIProgressView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.progressView.setProgress(0.0, animated: false)

        dispatch_async(dispatch_get_main_queue()) {
            for var space in MyVars.monopolyBoard {
                let task: AWSTask = space.dowload_image()

                task.continueWithBlock { (task) -> AnyObject! in
                    if task.error != nil {
                        print(task.error)
                    } else {
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            let updatedProgress =
                                self.progressView.progress + 1 / Float(MyVars.monopolyBoard.count)
                            self.progressView.setProgress(updatedProgress, animated: true)
                            print("Finished downloading image: \(space.boardIndex)")
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
                destinationVC.boardSpace = MyVars.gameBoard.getBoardSpace(0)
        }
    }
}
