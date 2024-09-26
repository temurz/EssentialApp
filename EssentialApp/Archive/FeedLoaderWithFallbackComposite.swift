//
//  FeedLoaderWithFallbackComposite.swift
//  EssentialApp
//
//  Created by Temur on 22/03/2024.
//

import Foundation
import EssentialFeedMacos
//public class FeedLoaderWithFallbackComposite: FeedLoader {
//    private let primary: FeedLoader
//    private let fallback: FeedLoader
//    public init(primary: FeedLoader, fallback: FeedLoader) {
//        self.primary = primary
//        self.fallback = fallback
//    }
//    
//    public func load(completion: @escaping (Swift.Result<[FeedImage], Error>) -> Void) {
//        primary.load { [weak self] result in
//            switch result {
//            case let .success(feed):
//                completion(.success(feed))
//            case .failure:
//                self?.fallback.load(completion: completion)
//            }
//        }
//    }
//}
