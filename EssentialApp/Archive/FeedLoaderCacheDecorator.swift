//
//  FeedLoaderCacheDecorator.swift
//  EssentialApp
//
//  Created by Temur on 02/04/2024.
//

import EssentialFeedMacos
//public class FeedLoaderCacheDecorator: FeedLoader {
//    let decoratee: FeedLoader
//    let cache: FeedCache
//    public init(decoratee: FeedLoader, cache: FeedCache) {
//        self.decoratee = decoratee
//        self.cache = cache
//    }
//    
//    public func load(completion: @escaping (Swift.Result<[FeedImage], Error>) -> Void) {
//        decoratee.load { [weak self] result in
//            completion(result.map({ feed in
//                self?.cache.saveIgnoringResult(feed)
//                return feed
//            }))
//        }
//    }
//}

extension FeedCache {
    func saveIgnoringResult(_ feed: [FeedImage]) {
        save(feed) { _ in }
    }
}
