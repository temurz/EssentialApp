//
//  FeedLoaderCacheDecoratorTests.swift
//  EssentialAppTests
//
//  Created by Temur on 02/04/2024.
//

import XCTest
import EssentialFeedMacos
import EssentialApp
//class FeedLoaderCacheDecoratorTests: XCTestCase, FeedLoaderTestCase {
//    
//    func test_load_deliversFeedOnLoaderSuccess() {
//        let feed = uniqueFeed()
//        let sut = makeSUT(loaderResult: .success(feed))
//        
//        expect(sut, toCompleteWith: .success(feed))
//    }
//    
//    func test_load_deliversErrorOnLoaderFailure() {
//        let sut = makeSUT(loaderResult: .failure(anyNSError()))
//        
//        expect(sut, toCompleteWith: .failure(anyNSError()))
//    }
//    
//    func test_load_cachesFeedOnLoaderSuccess() {
//        let cache = CacheSpy()
//        let feed = uniqueFeed()
//        let sut = makeSUT(loaderResult: .success(feed), cache: cache)
//        
//        sut.load { _ in }
//        
//        XCTAssertEqual(cache.messages, [.save(feed)])
//    }
//    
//    func test_load_doesNotCacheOnLoaderFailure() {
//        let cache = CacheSpy()
//        let sut = makeSUT(loaderResult: .failure(anyNSError()), cache: cache)
//        
//        sut.load { _ in }
//        
//        XCTAssertEqual(cache.messages, [])
//    }
//    
//    private func makeSUT(loaderResult: Swift.Result<[FeedImage], Error>, cache: CacheSpy = .init(), file: StaticString = #file, line: UInt = #line) -> FeedLoader {
//        let loader = FeedLoaderStub(result: loaderResult)
//        let sut = FeedLoaderCacheDecorator(decoratee: loader, cache: cache)
//        trackForMemoryLeaks(loader)
//        trackForMemoryLeaks(sut)
//        return sut
//    }
//    
//    private class CacheSpy: FeedCache {
//        private(set) var messages = [Message]()
//        
//        enum Message: Equatable {
//            case save(_ feed: [FeedImage])
//        }
//        
//        func save(_ feed: [EssentialFeedMacos.FeedImage], completion: @escaping (FeedCache.Result) -> ()) {
//            messages.append(.save(feed))
//            completion(.success(()))
//        }
//    }
//}
