//
//  hiraafood_xcode_10UITests.swift
//  hiraafood-xcode-10UITests
//
//  Created by Pinaki Poddar on 7/17/20.
//  Copyright © 2020 Digital Artisan. All rights reserved.
//

import XCTest
import UIKit
@testable import hiraafood

class hiraafood_xcode_10UITests: XCTestCase {
    override func setUp() {
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testCounter() {
        let nav:UINavigationController? = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController
        let counter = Counter(text: "How may items? ", start: 23)
        let vc:UIViewController = UIViewController()
        vc.view.addSubview(counter)
        nav?.pushViewController(vc, animated: true)
    
    }

}
