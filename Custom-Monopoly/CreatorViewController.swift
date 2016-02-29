//
//  CreatorViewController.swift
//  Custom-Monopoly
//
//  Created by David Mattia on 2/26/16.
//  Copyright © 2016 David Mattia. All rights reserved.
//

import UIKit
import KTCenterFlowLayout
import Firebase

class CreatorViewController : UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var boardSpaceCollectionView: UICollectionView!
    private let gameSets : [BoardSpaceSet] = [
        BoardSpaceSet(name: "Brown Pieces", space_indices: [1, 3], color: MaterialColor.brown.base),
        BoardSpaceSet(name: "Light Blue Pieces", space_indices: [6, 8, 9], color: MaterialColor.blue.lighten2),
        BoardSpaceSet(name: "Purple Pieces", space_indices: [11, 13, 14], color: MaterialColor.purple.lighten1),
        BoardSpaceSet(name: "Orange Pieces", space_indices: [16, 18, 19], color: MaterialColor.orange.base),
        BoardSpaceSet(name: "Red Pieces", space_indices: [21, 23, 24], color: MaterialColor.red.base),
        BoardSpaceSet(name: "Yellow Pieces", space_indices: [26, 27, 29], color: MaterialColor.yellow.darken2),
        BoardSpaceSet(name: "Green Pieces", space_indices: [31, 32, 34], color: MaterialColor.green.base),
        BoardSpaceSet(name: "Blue Pieces", space_indices: [37, 39], color: MaterialColor.blue.darken1)
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        self.boardSpaceCollectionView.delegate = self
        self.boardSpaceCollectionView.dataSource = self
        
        let collectionViewLayout : UICollectionViewFlowLayout = self.boardSpaceCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        collectionViewLayout.headerReferenceSize = CGSize(width: 0, height: 30)
        
        self.title = "Create A Board!"
        let saveButton = UIBarButtonItem(title: "Save", style: .Done, target: self, action: "saveClicked:")
        self.navigationItem.rightBarButtonItem = saveButton
    }
    
    func saveClicked(sender: UIBarButtonItem) {
        let ref = Firebase(url:"https://blistering-fire-9767.firebaseio.com/")
        let boardRef = ref.childByAppendingPath("Test")
        
        for set in gameSets {
            for space in set.getSpaces() {
                let json : [String : AnyObject] = [
                    "name": space.space_name,
                    "price": (space as? Ownable)?.price ?? 0,
                    "image": space.image_location
                ]
                boardRef.childByAppendingPath("Property \(space.board_index)").setValue(json)
            }
        }
    }
    
    func collectionView(collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
            switch kind {
            case UICollectionElementKindSectionHeader:
                let headerView =
                collectionView.dequeueReusableSupplementaryViewOfKind(kind,
                    withReuseIdentifier: "sectionHeader",
                    forIndexPath: indexPath)
                    as! CreatorHeaderView
                headerView.headerLabel.backgroundColor = MaterialColor.blue.base
                headerView.headerLabel.text = gameSets[indexPath.section].getName()
                headerView.headerLabel.backgroundColor = gameSets[indexPath.section].getColor()
                return headerView
            default:
                assert(false, "Unexpected element kind")
            }
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        print("Selected cell at: \(indexPath)")
        
        self.performSegueWithIdentifier("showPreview", sender: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showPreview" {
            let destinationVC = segue.destinationViewController as! PreviewViewController
            
            let clickedIndexPath = self.boardSpaceCollectionView.indexPathsForSelectedItems()?[0]
            let spaceClicked = gameSets[clickedIndexPath!.section].getSpaceAtIndex(clickedIndexPath!.row)
            
            destinationVC.propertyColor = gameSets[clickedIndexPath!.section].getColor()
            destinationVC.propertyName = spaceClicked.space_name
            destinationVC.cost = (spaceClicked as? Ownable)?.price
        }
    }
    
    func collectionView(collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAtIndex section: Int) -> UIEdgeInsets {
            
            let itemsInSection = self.boardSpaceCollectionView.numberOfItemsInSection(section)
            let frameWidth = self.boardSpaceCollectionView.frame.width
            let imageWidth = (frameWidth / 4)
            let left_margin = (frameWidth - imageWidth * CGFloat(itemsInSection)) / 2.0
            
            print("The frame is \(frameWidth) wide")
            print("The width of the images are \(imageWidth)")
            print("There are \(itemsInSection) items in section \(section)")
            print("Left margins: \(left_margin)")
            print("-------------------------------------")
            
            return UIEdgeInsets(top: 20,
                left: left_margin - 30,
                bottom: 20,
                right: left_margin - 30)
    }
    
    func collectionView(collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
            return 50.0
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = self.boardSpaceCollectionView.dequeueReusableCellWithReuseIdentifier("collectionCellId", forIndexPath: indexPath) as! CreatorCell
        
        cell.nameLabel.text = gameSets[indexPath.section].getNameAtIndex(indexPath.row)
        cell.nameLabel.minimumScaleFactor = 0.3
        cell.nameLabel.adjustsFontSizeToFitWidth = true
        cell.nameLabel.numberOfLines = 2
        //cell.backgroundColor = MaterialColor.blue.base
        cell.backgroundColor = gameSets[indexPath.section].getColor()
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return gameSets[section].getNumberOfSpacesInSet()
    }
    
    func collectionView(collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
            let frameWidth = self.boardSpaceCollectionView.frame.width
            let imageWidth = frameWidth / 4
            return CGSize(width: imageWidth, height: imageWidth * 1.25)
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return gameSets.count
    }
}
