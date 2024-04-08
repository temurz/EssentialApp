//
//  SceneDelegateTests.swift
//  EssentialAppTests
//
//  Created by Temur on 08/04/2024.
//

import XCTest
@testable import EssentialApp
import EssentialFeediOS
class SceneDelegateTests: XCTestCase {
    func test_sceneWillConnectTo_configuresRootViewController() {
        let sut = SceneDelegate()
        
        sut.window = UIWindow()
        
        sut.configureWindow()
        
        let root = sut.window?.rootViewController
        let rootNavigation = root as? UINavigationController
        let topController = rootNavigation?.topViewController
        
        XCTAssertNotNil(rootNavigation, "Expected navigation controller as a root controller, got \(String(describing: root)) instead")
        XCTAssertTrue(topController is FeedViewController, "Expected a feed controller as a top controller, got \(String(describing: topController)) instead" )
    }
}
