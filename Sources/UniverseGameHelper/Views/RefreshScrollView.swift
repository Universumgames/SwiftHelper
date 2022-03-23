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
    var content: () -> ContentType

    public init(_ refreshAction: @escaping () -> Void, @ViewBuilder content: @escaping () -> ContentType) {
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
    var content: UIView

    init(width: CGFloat, height: CGFloat, refreshAction: @escaping () -> Void, @ViewBuilder content: () -> ContentType) {
        self.width = width
        self.height = height
        self.refreshAction = refreshAction
        self.content = UIHostingController(rootView: content()).view
    }

    func makeUIView(context: Context) -> UIScrollView {
        content.translatesAutoresizingMaskIntoConstraints = false
        let scrollView = UIScrollView()
        scrollView.refreshControl = UIRefreshControl()
        scrollView.refreshControl?.addTarget(context.coordinator, action: #selector(Coordinator.handleRefreshControl(sender:)), for: .valueChanged)

        scrollView.addSubview(content)

        let constraints = [
            content.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            content.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            content.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            content.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            content.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
        ]
        scrollView.addConstraints(constraints)

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
