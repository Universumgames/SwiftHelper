//
//  RefreshScrollView.swift
//  ConfMan
//
//  Created by Tom Arlt on 21.03.22.
//

import SwiftUI
import UIKit

public struct PullToRefreshView<ContentType: View>: View {
    var refreshAction: () -> Void
    var content: ContentType

    public init(_ refreshAction: @escaping () -> Void, content: ContentType) {
        self.refreshAction = refreshAction
        self.content = content
    }

    public var body: some View {
        GeometryReader { reader in
            RefreshScrollViewContainer(width: reader.size.width, height: reader.size.height, refreshAction: refreshAction, content: content)
        }
    }
}

private struct RefreshScrollViewContainer<ContentType: View>: UIViewRepresentable {
    var width: CGFloat
    var height: CGFloat

    var refreshAction: () -> Void
    var content: ContentType

    func makeUIView(context: Context) -> UIScrollView {
        let scrollView = UIScrollView()
        scrollView.refreshControl = UIRefreshControl()
        scrollView.refreshControl?.addTarget(context.coordinator, action: #selector(Coordinator.handleRefreshControl(sender:)), for: .valueChanged)

        let refreshVC = UIHostingController(rootView: content)
        refreshVC.view.frame = CGRect(x: 0, y: 0, width: width, height: height)

        scrollView.addSubview(refreshVC.view)

        return scrollView
    }

    func updateUIView(_ uiView: UIScrollView, context: Context) {}

    func makeCoordinator() -> Coordinator<ContentType> {
        Coordinator(self, refreshAction: refreshAction)
    }

    class Coordinator<ContentType: View>: NSObject {
        var refreshScrollView: RefreshScrollViewContainer<ContentType>
        var refreshAction: () -> Void

        init(_ refreshScrollView: RefreshScrollViewContainer<ContentType>, refreshAction: @escaping () -> Void) {
            self.refreshScrollView = refreshScrollView
            self.refreshAction = refreshAction
        }

        @objc func handleRefreshControl(sender: UIRefreshControl) {
            sender.endRefreshing()
            refreshAction()
        }
    }
}
