//
//  RefreshableScrollView.swift
//  ConfMan
//
//  Created by Tom Arlt on 06.08.22.
//

import SwiftUI

@available(watchOS, unavailable)
public struct RefreshableScrollView<Content: View>: View {
    @Binding private var isRefreshing: Bool
    @State private var offset: CGFloat = 0
    @State private var canRefresh: Bool = true
    private var content: () -> Content
    private let threshold: CGFloat = 50.0

    public init(
        isRefreshing: Binding<Bool>,
        @ViewBuilder content: @escaping () -> Content
    ) {
        _isRefreshing = isRefreshing
        self.content = content
    }

    public var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack(spacing: 0) {
                    if isRefreshing || !canRefresh {
                        ProgressView()
                            .progressViewStyle(
                                CircularProgressViewStyle(tint: Color.purple)
                            )
                    }
                    content()
                        .anchorPreference(key: OffsetPreferenceKey.self, value: .top) {
                            geometry[$0].y
                        }
                }
            }
            .onPreferenceChange(OffsetPreferenceKey.self) { offset in
                DispatchQueue.main.async {
                    if canRefresh {
                        self.offset = offset
                        if offset > threshold && canRefresh {
                            withAnimation {
                                /// In case u need haptic feel
                                hapticSuccess()
                                isRefreshing = true
                            }
                            canRefresh = false
                        }
                    } else {
                        if offset < 21 {
                            canRefresh = true
                        }
                    }
                }
            }
            .animation(.easeInOut, value: isRefreshing)
        }
    }
}

fileprivate struct OffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0

    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

public extension View {
    

    /// In case u need a modifier
    //func refreshable(action: @escaping () -> Void) -> some View {
    //    modifier(RefreshableScrollViewModifier(action: action))
    //}
}

/*struct RefreshableScrollViewModifier: ViewModifier {
    var action: () -> Void
    @State private var isRefreshing: Bool = false

    func body(content: Content) -> some View {
        RefreshableScrollView(isRefreshing: $isRefreshing) {
            content
        }.onChange(of: isRefreshing) { newVal in
            if newVal {
                action()
                isRefreshing = false
            }
        }
    }
}
*/
