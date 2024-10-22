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
import Combine
class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    private lazy var httpClient: HTTPClient = {
        URLSessionHTTPClient(session: URLSession(configuration: .ephemeral))
    }()
    private lazy var store: FeedStore & FeedImageDataStore = {
        try! CoreDataFeedStore(storeURL: 
                                NSPersistentContainer
            .defaultDirectoryURL()
            .appendingPathComponent("feed-store.sqlite")
        )
    }()
    
    private lazy var localFeedLoader: LocalFeedLoader = {
        LocalFeedLoader(store: store, currentDate: Date.init)
    }()
    
    private lazy var navigationController = UINavigationController(rootViewController:  FeedUIComposer.feedComposeWith(
        feedLoader:
            makeRemoteFeedLoaderWithLocalFallback,
        imageLoader:
            makeLocalImageLoaderWithRemoteFallback,
        selection: showComments
        )
    )

    private lazy var baseURL = URL(string: "https://ile-api.essentialdeveloper.com/essential-feed")!
    
    convenience init(httpClient: HTTPClient, store: FeedStore & FeedImageDataStore) {
        self.init()
        self.httpClient = httpClient
        self.store = store
    }
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: scene)
        configureWindow()
    }
    
    func configureWindow() {
//        let url = URL(string: "https://ile-api.essentialdeveloper.com/essential-feed/v1/feed")!
        
//        let remoteClient = httpClient
//        let remoteFeedLoader = RemoteFeedLoader(url: url, client: remoteClient)
//        let remoteImageLoader = RemoteFeedImageDataLoader(client: remoteClient)
        
//        let localImageLoader = LocalFeedImageDataLoader(store: store)
        
        
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
    
    func showComments(for image: FeedImage) {
        let url = baseURL.appendingPathComponent("/v1/image/\(image.id)/comments")
        let comments = CommentsUIComposer.commentsComposedWith(commentsLoader: makeRemoteCommentsLoader(url: url))
        navigationController.pushViewController(comments, animated: true)
    }
    
    private func makeRemoteCommentsLoader(url: URL) -> () -> AnyPublisher<[ImageComment], Error> {
        return { [httpClient] in
            return httpClient
                .getPublisher(url: url)
                .tryMap(ImageCommentsMapper.map)
                .eraseToAnyPublisher()
        }
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        localFeedLoader.validateCache { _ in }
    }
    
    func makeRemoteFeedLoaderWithLocalFallback() -> AnyPublisher<[FeedImage], Error> {
//        let remoteURL = URL(string:"https://static1.squarespace.com/static/5891c5b8d1758ec68ef5dbc2/t/5db4155a4fbade21d17ecd28/1572083034355/essential _app_feed.json")!
        let remoteURL = baseURL.appendingPathComponent("/v1/feed") 
//        let remoteFeedLoader = httpClient.getPublisher(url: remoteURL)
        
        return httpClient
            .getPublisher(url: remoteURL)
            .tryMap(FeedItemsMapper.map)
            .caching(to: localFeedLoader)
            .fallback(to: localFeedLoader.loadPublisher)
    }
    
    func makeLocalImageLoaderWithRemoteFallback(url: URL) -> FeedImageDataLoader.Publisher {
        
        let localImageLoader = LocalFeedImageDataLoader(store: store)
        
        return localImageLoader
            .loadImageDataPublisher(from: url)
            .fallback { [httpClient] in
                httpClient
                    .getPublisher(url: url)
                    .tryMap(FeedImageDataMapper.map)
                    .caching(to: localImageLoader, using: url)
            }
        
    }
}

//extension RemoteLoader: FeedLoader where Resource == [FeedImage] {}
