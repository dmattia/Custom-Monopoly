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

/*
class BoardSpace {
    internal var space_name : String
    internal var board_index : Int
    internal var image_location : String // Location of image on S3 server
    internal var image : UIImage? // image returned from S3 server
    
    init(name: String, index: Int, image_location: String) {
        self.space_name = name
        self.board_index = index
        self.image_location = image_location
    }
    
    func dowload_image() {
        let downloadingFilePath1 = NSTemporaryDirectory() + "temp-download"
        let downloadingFileURL1 = NSURL(fileURLWithPath: downloadingFilePath1)
        let transferManager = AWSS3TransferManager.defaultS3TransferManager()
        
        let readRequest1 : AWSS3TransferManagerDownloadRequest = AWSS3TransferManagerDownloadRequest()
        readRequest1.bucket = "custom-monopoly"
        readRequest1.key = self.image_location
        readRequest1.downloadingFileURL = downloadingFileURL1
        
        let task = transferManager.download(readRequest1)
        task.continueWithBlock { (task) -> AnyObject! in
            if task.error != nil {
                print(task.error)
            } else {
                dispatch_async(dispatch_get_main_queue()
                    , { () -> Void in
                        self.image = UIImage(contentsOfFile: downloadingFilePath1)
                        print("Finished downloading image: \(self.image_location)")
                })
            }
            return nil
        }
    }
}

// Any chance, comunity chest, or corner spot
class MiscSpace : BoardSpace {
    override init(name: String, index: Int, image_location : String) {
        super.init(name: name, index: index, image_location: image_location)
        super.dowload_image()
    }
}
*/

protocol BoardSpace {
    var space_name : String {get}
    var board_index : Int {get}
    var image_location : String {get} // Location of image on S3 server
    var image : UIImage? {get set} // image returned from S3 server
}

extension BoardSpace {
    func on_land() {
        print("landed on space: \(self.space_name)")
    }
    func on_leave() {
        print("leaving space: \(self.space_name)")
    }
    mutating func dowload_and_return_image() {
        let downloadingFilePath1 = NSTemporaryDirectory() + "temp-download"
        let downloadingFileURL1 = NSURL(fileURLWithPath: downloadingFilePath1)
        let transferManager = AWSS3TransferManager.defaultS3TransferManager()
        
        let readRequest1 : AWSS3TransferManagerDownloadRequest = AWSS3TransferManagerDownloadRequest()
        readRequest1.bucket = "custom-monopoly"
        readRequest1.key = self.image_location
        readRequest1.downloadingFileURL = downloadingFileURL1
        
        let task = transferManager.download(readRequest1)
        task.continueWithBlock { (task) -> AnyObject! in
            if task.error != nil {
                print(task.error)
            } else {
                dispatch_async(dispatch_get_main_queue()
                    , { () -> Void in
                        self.image = UIImage(contentsOfFile: downloadingFilePath1)
                        print("Finished downloading image: \(self.image_location)")
                })
            }
            return nil
        }
    }
}

protocol Ownable : BoardSpace {
    var space_name : String {get}
    var price : Int {get}
    var owner : Player? {get}
}

extension Ownable {
    func on_buy() {
        print("Bought property: \(self.space_name)")
    }
    func on_mortgage() {
        print("Mortgaged property: \(self.space_name)")
    }
}

class Property: Ownable {
    var board_index : Int
    var space_name : String
    var image_location : String
    var image : UIImage?
    
    var price : Int
    var color : UIColor
    var owner : Player?
    
    init(name: String, cost: Int, index: Int, color: UIColor, image_location: String = "") {
        self.space_name = name
        self.price = cost
        self.board_index = index
        self.color = color
        self.owner = nil
        self.image_location = image_location
    }
}

class Railroad : Ownable {
    var board_index : Int
    var space_name : String
    var image_location : String
    var image : UIImage?
    
    var price : Int
    var owner : Player?
    
    init(name: String, cost: Int, index: Int, image_location : String = "") {
        self.space_name = name
        self.price = cost
        self.board_index = index
        self.owner = nil
        self.image_location = image_location
    }
}

class MiscSpace : BoardSpace {
    // Any chance, comunity chest, or corner spot
    var space_name : String
    var board_index : Int
    var image_location : String
    var image : UIImage?
    
    init(name: String, index: Int, image_location : String = "") {
        self.space_name = name
        self.board_index = index
        self.image_location = image_location
    }
}

