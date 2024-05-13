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
    
    func test_configureWindow_setsWindowAsKeyAndVisible() {
        let window = UIWindowSpy()
        let sut = SceneDelegate()
        sut.window = window
        
        sut.configureWindow()
        XCTAssertEqual(window.makeKeyAndVisibleCallCount, 1, "Expected window to be the key window and visible")
    }
    
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
    
    private class UIWindowSpy: UIWindow {
      var makeKeyAndVisibleCallCount = 0

      override func makeKeyAndVisible() {
        makeKeyAndVisibleCallCount += 1
      }
    }
}
