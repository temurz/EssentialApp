//
//  FeedImageDataLoaderWithFallback.swift
//  EssentialAppTests
//
//  Created by Temur on 22/03/2024.
//

import XCTest
import EssentialFeedMacos
class FeedImageDataLoaderWithFallbackComposite: FeedImageDataLoader {
    private let primaryLoader: FeedImageDataLoader
    private let fallbackLoader: FeedImageDataLoader
    init(primary: FeedImageDataLoader, fallback: FeedImageDataLoader) {
        self.primaryLoader = primary
        self.fallbackLoader = fallback
    }
    
    private class TaskWrapper: FeedImageDataLoaderTask {
        var wrapped: FeedImageDataLoaderTask?
        
        func cancel() {
            wrapped?.cancel()
        }
    }
    
    func loadImageData(from url: URL, completion: @escaping (FeedImageDataLoader.Result) -> Void) -> FeedImageDataLoaderTask {
        var task = TaskWrapper()
        task.wrapped = primaryLoader.loadImageData(from: url) { result in
            switch result {
            case let .success(imageData):
                completion(.success(imageData))
            case .failure:
                task.wrapped = self.fallbackLoader.loadImageData(from: url) { result in
                    completion(result)
                }
            }
        }
        
        return task
    }
}


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
            var task = TaskWrapper()
            completion(result)
            return task
        }
        
        
    }
}

private extension UIImage {
    static func make(withColor color: UIColor) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        let format = UIGraphicsImageRendererFormat()
        format.scale = 1
        
        return UIGraphicsImageRenderer(size: rect.size, format: format).image { rendererContext in
            color.setFill()
            rendererContext.fill(rect)
        }
    }
}
