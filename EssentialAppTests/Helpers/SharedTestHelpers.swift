//
//  SharedTestHelpers.swift
//  EssentialAppTests
//
//  Created by Temur on 02/04/2024.
//

import EssentialFeedMacos
func anyNSError() -> NSError {
    return NSError(domain: "any error", code: 0)
}

func uniqueFeed() -> [FeedImage] {
    return [FeedImage(id: UUID(), description: nil, location: nil, imageURL: URL(string: "http://any-url.com")!)]
}
