//
//  BoardSpace.swift
//  Custom-Monopoly
//
//  Created by David Mattia on 2/20/16.
//  Copyright © 2016 David Mattia. All rights reserved.
//

import UIKit
import AWSCore
import AWSCognito
import AWSS3
import AWSDynamoDB
import AWSSQS
import AWSSNS

protocol BoardSpace {
    var spaceName: String {get}
    var boardIndex: Int {get}
    var imageLocation: String {get} // Location of image on S3 server
    var image: UIImage? {get set} // image returned from S3 server
}

extension BoardSpace {
    func on_land() {
        print("landed on space: \(self.spaceName)")
    }
    func on_leave() {
        print("leaving space: \(self.spaceName)")
    }
    mutating func dowload_image() -> AWSTask {
        let downloadingFilePath1 = NSTemporaryDirectory() + "temp-download"
        let downloadingFileURL1 = NSURL(fileURLWithPath: downloadingFilePath1)
        let transferManager = AWSS3TransferManager.defaultS3TransferManager()

        let readRequest1: AWSS3TransferManagerDownloadRequest =
            AWSS3TransferManagerDownloadRequest()
        readRequest1.bucket = "custom-monopoly"
        readRequest1.key = self.imageLocation
        readRequest1.downloadingFileURL = downloadingFileURL1

        let task = transferManager.download(readRequest1)
        return task.continueWithBlock { (task) -> AnyObject! in
            if task.error != nil {
                print(task.error)
            } else {
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.image = UIImage(contentsOfFile: downloadingFilePath1)
                        print("Finished downloading image: \(self.imageLocation)")
                })
            }
            return nil
        }
    }
}

protocol Ownable: BoardSpace {
    var spaceName: String {get}
    var price: Int {get}
    var owner: Player? {get}
}

extension Ownable {
    func on_buy() {
        print("Bought property: \(self.spaceName)")
    }
    func on_mortgage() {
        print("Mortgaged property: \(self.spaceName)")
    }
}

class Property: Ownable {
    var boardIndex: Int
    var spaceName: String
    var imageLocation: String
    var image: UIImage?

    var price: Int
    var color: UIColor
    var owner: Player?

    init(name: String,
        cost: Int,
        index: Int,
        color: UIColor,
        imageLocation: String = "Harry Potter/harry.jpg") {
        self.spaceName = name
        self.price = cost
        self.boardIndex = index
        self.color = color
        self.owner = nil
        self.imageLocation = imageLocation
    }
}

class Railroad: Ownable {
    var boardIndex: Int
    var spaceName: String
    var imageLocation: String
    var image: UIImage?

    var price: Int
    var owner: Player?

    init(name: String, cost: Int, index: Int, imageLocation: String = "Harry Potter/harry.jpg") {
        self.spaceName = name
        self.price = cost
        self.boardIndex = index
        self.imageLocation = imageLocation
        self.owner = nil
    }
}

class TaxSpace: BoardSpace {
    var spaceName: String
    var boardIndex: Int
    var imageLocation: String
    var image: UIImage?
    var price: Int

    init(name: String, cost: Int, index: Int, imageLocation: String = "Harry Potter/harry.jpg") {
        self.spaceName = name
        self.price = cost
        self.boardIndex = index
        self.imageLocation = imageLocation
    }
}

class MiscSpace: BoardSpace {
    // Any chance, comunity chest, or corner spot
    var spaceName: String
    var boardIndex: Int
    var imageLocation: String
    var image: UIImage?

    init(name: String, index: Int, imageLocation: String = "Harry Potter/harry.jpg") {
        self.spaceName = name
        self.boardIndex = index
        self.imageLocation = imageLocation
    }
}
