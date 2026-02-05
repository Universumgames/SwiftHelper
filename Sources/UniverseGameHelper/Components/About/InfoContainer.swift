//
//  InfoContainer.swift
//
//
//  Created by Tom Arlt on 17.03.24.
//

import MarkdownUI
import SwiftUI

public struct InfoContainer: View {
    @State private var showInfo = false
    let infoText: String
    let defaultCornerRadius: CGFloat
    let secondaryBackground: Color
    
    public init(
        showInfo: Bool = false,
        infoText: String,
        defaultCornerRadius: CGFloat,
        secondaryBackground: Color
    ) {
        self.showInfo = showInfo
        self.infoText = infoText
        self.defaultCornerRadius = defaultCornerRadius
        self.secondaryBackground = secondaryBackground
    }

    public var body: some View {
        ListElement() {
            HStack {
                Text("about.button.information".localisedInBundle(.module))
                Spacer()
                Image(systemName: "chevron.right")
                    .rotationEffect(.degrees(showInfo ? 90 : 0))
                    .animation(.easeInOut, value: showInfo)
            }
            .background(secondaryBackground)
            .cornerRadius(defaultCornerRadius)

            if showInfo {
                VStack {
                    Markdown(infoText)
                }
                .padding()
                .transition(.scale.animation(.easeInOut(duration: 0.25)))
            }
        }
        .onTapGesture {
            withAnimation {
                showInfo.toggle()
            }
        }
    }
}

#Preview {
    InfoContainer(infoText: "test", defaultCornerRadius: 10, secondaryBackground: .red)
}
