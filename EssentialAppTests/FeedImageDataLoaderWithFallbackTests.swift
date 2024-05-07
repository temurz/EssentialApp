//
//  FeedImageDataLoaderWithFallback.swift
//  EssentialAppTests
//
//  Created by Temur on 22/03/2024.
//

import XCTest
import EssentialFeedMacos
import EssentialApp
class FeedImageDataLoaderWithFallbackTests: XCTestCase {
    
    func test_load_deliversPrimaryDataOnPrimaryLoaderSuccess() {
        let primaryImage = anyImageData(color: .red)
        let fallbackImage = anyImageData(color: .blue)
        let sut = makeSUT(primary: .success(primaryImage), fallback: .success(fallbackImage))
        
        expect(sut, toCompleteWith: .success(primaryImage))
    }
    
    func test_load_deliversFallbackDataOnPrimaryLoaderFailure() {
        let fallbackImage = anyImageData(color: .blue)
        let sut = makeSUT(primary: .failure(anyNSError()), fallback: .success(fallbackImage))
        
        expect(sut, toCompleteWith: .success(fallbackImage))
    }
    
    func test_load_deliversErrorOnBothPrimaryAndFallbackLoadersFailure() {
        let sut = makeSUT(primary: .failure(anyNSError()), fallback: .failure(anyNSError()))
        
        expect(sut, toCompleteWith: .failure(anyNSError()))
    }
    
    
    //MARK: - Helpers
    
    private func makeSUT(primary: FeedImageDataLoader.Result, fallback: FeedImageDataLoader.Result) -> FeedImageDataLoader {
        let primaryLoader = ImageLoaderStub(result: primary)
        let fallbackLoader = ImageLoaderStub(result: fallback)
        let sut = FeedImageDataLoaderWithFallbackComposite(primary: primaryLoader, fallback: fallbackLoader)
        trackForMemoryLeaks(sut)
        return sut
    }
    
    private func expect(_ sut: FeedImageDataLoader, toCompleteWith expectedResult: FeedImageDataLoader.Result, file: StaticString = #file, line: UInt = #line) {
        let exp = expectation(description: "Wait for load completion")
        let url = URL(string: "http://any-url.com")!
        _ = sut.loadImageData(from: url) { receivedResult in
            switch (receivedResult, expectedResult) {
            case let (.success(receivedImage), .success(expectedImage)):
                XCTAssertEqual(receivedImage, expectedImage)
            case (.failure, .failure):
                break
            default:
                XCTFail("Expected successful result, got \(receivedResult) instead!")
            }
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)
    }
    
    func anyImageData(color: UIColor) -> Data {
        return UIImage.make(withColor: color).pngData()!
    }
    
    class ImageLoaderStub: FeedImageDataLoader {
        private let result: FeedImageDataLoader.Result
        init(result: FeedImageDataLoader.Result) {
            self.result = result
        }
        
        private class TaskWrapper: FeedImageDataLoaderTask {
            var wrapped: FeedImageDataLoaderTask?
            
            func cancel() {
                wrapped?.cancel()
            }
        }
        
        func loadImageData(from url: URL, completion: @escaping (FeedImageDataLoader.Result) -> Void) -> EssentialFeedMacos.FeedImageDataLoaderTask {
            let task = TaskWrapper()
            completion(result)
            return task
        }
        
        
    }
}
