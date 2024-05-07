//
//  SceneDelegate.swift
//  EssentialApp
//
//  Created by Temur on 24/02/2024.
//

import UIKit
import EssentialFeedMacos
import EssentialFeediOS
import CoreData
class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    let localStoreURL = NSPersistentContainer
        .defaultDirectoryURL()
        .appendingPathComponent("feed-store.sqlite")
    
    private lazy var httpClient: HTTPClient = {
        URLSessionHTTPClient(session: URLSession(configuration: .ephemeral))
    }()
    private lazy var store: FeedStore & FeedImageDataStore = {
        try! CoreDataFeedStore(storeURL: localStoreURL)
    }()
    
    convenience init(httpClient: HTTPClient, store: FeedStore & FeedImageDataStore) {
        self.init()
        self.httpClient = httpClient
        self.store = store
    }
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let _ = (scene as? UIWindowScene) else { return }
        
        configureWindow()
    }
    
    func configureWindow() {
        let url = URL(string: "https://ile-api.essentialdeveloper.com/essential-feed/v1/feed")!
        
        let remoteClient = httpClient
        let remoteFeedLoader = RemoteFeedLoader(url: url, client: remoteClient)
        let remoteImageLoader = RemoteFeedImageDataLoader(client: remoteClient)
        
        let localFeedLoader = LocalFeedLoader(store: store, currentDate: Date.init)
        let localImageLoader = LocalFeedImageDataLoader(store: store)
        
        let viewController = UINavigationController(rootViewController:  FeedUIComposer.feedComposeWith(
            feedLoader:
                FeedLoaderWithFallbackComposite(
                    primary: FeedLoaderCacheDecorator(
                        decoratee: remoteFeedLoader,
                        cache: localFeedLoader),
                    fallback: localFeedLoader),
            imageLoader:
                FeedImageDataLoaderWithFallbackComposite(
                    primary: FeedImageDataLoaderCacheDecorator(
                        decoratee: remoteImageLoader,
                        cache: localImageLoader),
                    fallback: localImageLoader)
            )
        )
        window?.rootViewController = viewController
    }
    
    func makeRemoteClient() -> HTTPClient {
        return httpClient
    }
}
