//
//  EssentialAppTests.swift
//  EssentialAppTests
//
//  Created by Temur on 22/03/2024.
//

import XCTest
import EssentialFeedMacos
import EssentialApp
//final class FeedLoaderWithFallbackCompositeTests: XCTestCase, FeedLoaderTestCase {
//    
//    func test_load_deliversPrimaryFeedOnPrimaryLoaderSuccess() {
//        let primaryFeed = uniqueFeed()
//        let fallbackFeed = uniqueFeed()
//        let sut = makeSUT(primaryResult: .success(primaryFeed), fallbackResult: .success(fallbackFeed))
//        
//        expect(sut, toCompleteWith: .success(primaryFeed))
//        
//    }
//    
//    func test_load_deliversFallbackFeedOnPrimaryFailure() {
//        let fallbackFeed = uniqueFeed()
//        let sut = makeSUT(primaryResult: .failure(anyNSError()), fallbackResult: .success(fallbackFeed))
//        
//        expect(sut, toCompleteWith: .success(fallbackFeed))
//        
//    }
//    
//    func test_load_deliversErrorOnPrimaryAndFallbackLoadersFailure() {
//        let sut = makeSUT(primaryResult: .failure(anyNSError()), fallbackResult: .failure(anyNSError()))
//        expect(sut, toCompleteWith: .failure(anyNSError()))
//    }
//    
//    //MARK: - Helpers
//    
//    private func makeSUT(primaryResult: Swift.Result<[FeedImage], Error>, fallbackResult: Swift.Result<[FeedImage], Error>, file: StaticString = #file, line: UInt = #line) -> FeedLoader {
//        let primaryLoader = FeedLoaderStub(result: primaryResult)
//        let fallbackLoader = FeedLoaderStub(result: fallbackResult)
//        let sut = FeedLoaderWithFallbackComposite(primary: primaryLoader, fallback: fallbackLoader)
//        trackForMemoryLeaks(primaryLoader)
//        trackForMemoryLeaks(fallbackLoader)
//        trackForMemoryLeaks(sut)
//        return sut
//    }
//}
