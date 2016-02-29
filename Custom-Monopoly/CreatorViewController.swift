//
//  CreatorViewController.swift
//  Custom-Monopoly
//
//  Created by David Mattia on 2/26/16.
//  Copyright © 2016 David Mattia. All rights reserved.
//

import UIKit
import KTCenterFlowLayout

class CreatorViewController : UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var boardSpaceCollectionView: UICollectionView!
    private let counts : [Int] = [2, 3, 2, 3, 2, 2, 3, 3, 4, 4, 4]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.boardSpaceCollectionView.delegate = self
        self.boardSpaceCollectionView.dataSource = self
        
        let collectionViewLayout : UICollectionViewFlowLayout = self.boardSpaceCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        collectionViewLayout.headerReferenceSize = CGSize(width: 0, height: 30)
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
                headerView.headerLabel.text = "Section \(indexPath.section)"
                return headerView
            default:
                assert(false, "Unexpected element kind")
            }
    }
    
    func collectionView(collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAtIndex section: Int) -> UIEdgeInsets {
            
            let itemsInSection = self.boardSpaceCollectionView.numberOfItemsInSection(section)
            let frameWidth = self.boardSpaceCollectionView.frame.width
            //let screenWidth = UIScreen.mainScreen().bounds.width
            let imageWidth = (frameWidth / 5)
            let left_margin = (frameWidth - imageWidth * CGFloat(itemsInSection)) / 2.0
            
            print("The frame is \(frameWidth) wide")
            print("The width of the images are \(imageWidth)")
            print("There are \(itemsInSection) items in section \(section)")
            print("Left margins: \(left_margin)")
            print("-------------------------------------")
            
            return UIEdgeInsets(top: 20,
                left: left_margin - 20,
                bottom: 20,
                right: left_margin - 20)
    }
    
    func collectionView(collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
            return 50.0
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = self.boardSpaceCollectionView.dequeueReusableCellWithReuseIdentifier("collectionCellId", forIndexPath: indexPath)
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return counts[section]
    }
    
    func collectionView(collectionView: UICollectionView, canMoveItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func collectionView(collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
            let frameWidth = self.boardSpaceCollectionView.frame.width
            //let screenWidth = UIScreen.mainScreen().bounds.width
            let imageWidth = frameWidth / 5
            return CGSize(width: imageWidth, height: imageWidth)
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return counts.count
    }
}
