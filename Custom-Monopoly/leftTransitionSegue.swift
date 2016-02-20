//
//  leftTransitionSegue.swift
//  Custom-Monopoly
//
//  Created by David Mattia on 2/20/16.
//  Copyright © 2016 David Mattia. All rights reserved.
//

import UIKit

class leftTransitionSegue: UIStoryboardSegue {
    override func perform() {
        let source : UIViewController = self.sourceViewController
        let destination : UIViewController = self.destinationViewController
        UIView.transitionFromView(source.view,
            toView: destination.view,
            duration: 2.50,
            options: UIViewAnimationOptions.TransitionFlipFromRight,
            completion: nil)
    }
}
