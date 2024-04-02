//
//  FeedLoaderStub.swift
//  EssentialAppTests
//
//  Created by Temur on 02/04/2024.
//

import EssentialFeedMacos
class FeedLoaderStub: FeedLoader {
    private let result: FeedLoader.Result
    init(result: FeedLoader.Result) {
        self.result = result
    }
    
    func load(completion: @escaping (FeedLoader.Result) -> Void) {
        completion(result)
    }
}
