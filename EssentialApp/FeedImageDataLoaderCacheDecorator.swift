//
//  FeedImageDataLoaderCacheDecorator.swift
//  EssentialApp
//
//  Created by Temur on 07/05/2024.
//

import Foundation
import EssentialFeedMacos
public class FeedImageDataLoaderCacheDecorator: FeedImageDataLoader {
    let decoratee: FeedImageDataLoader
    let cache: FeedImageDataCache
    
    init(decoratee: FeedImageDataLoader, cache: FeedImageDataCache) {
        self.decoratee = decoratee
        self.cache = cache
    }
    
    public func loadImageData(from url: URL, completion: @escaping (FeedImageDataLoader.Result) -> Void) -> FeedImageDataLoaderTask {
        decoratee.loadImageData(from: url) { result in
            completion(result.map({ [weak self] data in
                self?.cache.save(data, for: url) { _ in }
                return data
            }))
        }
    }
    
    
}
