//
//  FeedImageDataLoaderWithFallbackComposite.swift
//  EssentialApp
//
//  Created by Temur on 22/03/2024.
//

import Foundation
import EssentialFeedMacos
public class FeedImageDataLoaderWithFallbackComposite: FeedImageDataLoader {
    private let primaryLoader: FeedImageDataLoader
    private let fallbackLoader: FeedImageDataLoader
    public init(primary: FeedImageDataLoader, fallback: FeedImageDataLoader) {
        self.primaryLoader = primary
        self.fallbackLoader = fallback
    }
    
    private class TaskWrapper: FeedImageDataLoaderTask {
        var wrapped: FeedImageDataLoaderTask?
        
        func cancel() {
            wrapped?.cancel()
        }
    }
    
    public func loadImageData(from url: URL, completion: @escaping (FeedImageDataLoader.Result) -> Void) -> FeedImageDataLoaderTask {
        let task = TaskWrapper()
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
