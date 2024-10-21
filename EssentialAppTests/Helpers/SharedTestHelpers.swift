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

private class DummyView: ResourceView {
    func display(_ viewModel: Any) {}
}

var loadError: String {
    LoadResourcePresenter<Any, DummyView>.loadError
}

var feedTitle: String {
    FeedPresenter.title
}

var commentsTitle: String {
    ImageCommentsPresenter.title
}
