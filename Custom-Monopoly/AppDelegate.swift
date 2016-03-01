//
//  AppDelegate.swift
//  Custom-Monopoly
//
//  Created by David Mattia on 2/19/16.
//  Copyright © 2016 David Mattia. All rights reserved.
//

import UIKit
import Firebase
import AWSCore
import AWSCognito

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {

        let credentialsProvider = AWSCognitoCredentialsProvider(regionType:.USEast1,
            identityPoolId:"us-east-1:f0c784bb-82f6-4dc4-a733-06a49389738e")

        let defaultServiceConfiguration = AWSServiceConfiguration(
            region: AWSRegionType.USEast1, credentialsProvider: credentialsProvider)

        AWSServiceManager.defaultServiceManager().defaultServiceConfiguration =
            defaultServiceConfiguration

        return true
    }
}
