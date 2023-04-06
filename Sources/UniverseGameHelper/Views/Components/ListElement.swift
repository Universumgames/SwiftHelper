//
//  ListElement.swift
//
//
//  Created by Tom Arlt on 23.02.22.
//

import SwiftUI

public struct ListElement<Content: View>: View {
    var cornerRadius: CGFloat
    var bgColor: Color
    var content: () -> Content

    public init(cornerRadius: CGFloat, bgColor: Color, @ViewBuilder content: @escaping () -> Content) {
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
        .background(bgColor)
        .cornerRadius(cornerRadius)
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
