//
//  CommentsUIComposer.swift
//  EssentialApp
//
//  Created by Temur on 26/09/2024.
//
import UIKit
import EssentialFeedMacos
import EssentialFeediOS
import Combine
public final class CommentsUIComposer {
    private init() {}
    
    public static func commentsComposedWith(commentsLoader: @escaping () -> AnyPublisher<[ImageComment], Error>) -> ListViewController {
        let presentationAdapter = LoadResourcePresentationAdapter<[ImageComment], CommentsViewAdapter>(loader: { commentsLoader().dispatchOnMainQueue() })
        
        let commentsViewController = makeCommentsViewController(title: ImageCommentsPresenter.title)
        commentsViewController.onRefresh = presentationAdapter.loadResource
        
        presentationAdapter.presenter = LoadResourcePresenter(
            errorView: WeakRefVirtualProxy(commentsViewController),
            loadingView: WeakRefVirtualProxy(commentsViewController),
            resourceView: CommentsViewAdapter(controller: commentsViewController), mapper: {
                                              ImageCommentsPresenter.map($0)
                                          } )
        return commentsViewController
    }
    
    private static func makeCommentsViewController(title: String) -> ListViewController {
        let bundle = Bundle(for: ListViewController.self)
        let storyboard = UIStoryboard(name: "ImageComments", bundle: bundle)
        let feedController = storyboard.instantiateInitialViewController() as! ListViewController
        feedController.title = title
        return feedController
    }
}

internal final class CommentsViewAdapter: ResourceView {
    private weak var controller: ListViewController?
    
    init(controller: ListViewController) {
        self.controller = controller
    }
    
    func display(_ viewModel: ImageCommentsViewModel) {
        controller?.display(viewModel.comments.map{ viewModel in CellController(id: viewModel, ImageCommentsCellController(model: viewModel)) })
    }
}
