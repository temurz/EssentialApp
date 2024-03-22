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
        
        let exp = expectation(description: "Wait for load completion")
        let url = URL(string: "http://any-url.com")!
        _ = sut.loadImageData(from: url) { result in
            switch result {
            case let .success(receivedImage):
                XCTAssertEqual(receivedImage, primaryImage)
            case .failure:
                XCTFail("Expected successful result, got \(result) instead!")
            }
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)
    }
    
    func test_load_deliversFallbackDataOnPrimaryLoaderFailure() {
        let fallbackImage = anyImageData(color: .blue)
        let sut = makeSUT(primary: .failure(anyNSError()), fallback: .success(fallbackImage))
        
        let exp = expectation(description: "Wait for load completion")
        let url = URL(string: "http://any-url.com")!
        _ = sut.loadImageData(from: url) { result in
            switch result {
            case let .success(receivedImage):
                XCTAssertEqual(receivedImage, fallbackImage)
            case .failure:
                XCTFail("Expected successful result, got \(result) instead!")
            }
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)
    }
    
    
    //MARK: - Helpers
    
    private func makeSUT(primary: FeedImageDataLoader.Result, fallback: FeedImageDataLoader.Result) -> FeedImageDataLoader {
        let primaryLoader = ImageLoaderStub(result: primary)
        let fallbackLoader = ImageLoaderStub(result: fallback)
        let sut = FeedImageDataLoaderWithFallbackComposite(primary: primaryLoader, fallback: fallbackLoader)
        trackForMemoryLeaks(sut)
        return sut
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
