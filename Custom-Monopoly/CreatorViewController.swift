//
//  CreatorViewController.swift
//  Custom-Monopoly
//
//  Created by David Mattia on 2/26/16.
//  Copyright © 2016 David Mattia. All rights reserved.
//

import UIKit

class CreatorViewController : UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var boardSpaceCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.boardSpaceCollectionView.delegate = self
        self.boardSpaceCollectionView.dataSource = self
        
        let collectionViewLayout : UICollectionViewFlowLayout = self.boardSpaceCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        collectionViewLayout.sectionInset = UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0)
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
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = self.boardSpaceCollectionView.dequeueReusableCellWithReuseIdentifier("collectionCellId", forIndexPath: indexPath)
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return random() % 3 + 2
    }
    
    func collectionView(collectionView: UICollectionView, canMoveItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func collectionView(collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
            let screenWidth = UIScreen.mainScreen().bounds.width
            let imageWidth = screenWidth / 5
            return CGSize(width: imageWidth, height: imageWidth)
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 20
    }
}
