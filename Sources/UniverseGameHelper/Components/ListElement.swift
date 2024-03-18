//
//  ListElement.swift
//
//
//  Created by Tom Arlt on 23.02.22.
//

import SwiftUI

public struct ListElement<Content: View>: View {
    @Environment(\.styling) var styling
    var cornerRadius: CGFloat?
    var bgColor: Color?
    var content: () -> Content

    public init(cornerRadius: CGFloat? = nil, bgColor: Color? = nil, @ViewBuilder content: @escaping () -> Content) {
        self.cornerRadius = cornerRadius
        self.bgColor = bgColor
        self.content = content
    }

    public var body: some View {
        VStack {
            Group(content: content)
        }
        .frame(
            minWidth: 0,
            maxWidth: .infinity,
            minHeight: 0,
            maxHeight: .infinity,
            alignment: .topLeading
        )
        .padding()
        .background(bgColor ?? styling.colors.secondaryBackground)
        .cornerRadius(cornerRadius ?? styling.defaultCornerRadius)
    }
}

struct ListElement_Previews: PreviewProvider {
    static var previews: some View {
        ListElement(cornerRadius: 20, bgColor: Color.gray) {
            VStack {
                Text("Hi")
            }
        }
        .previewLayout(.sizeThatFits)
    }
}
