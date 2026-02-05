//
//  GitHubLink.swift
//  
//
//  Created by Tom Arlt on 17.03.24.
//

import SwiftUI

public struct GitHubLinkButton: View {
    let secondaryBackground: Color
    let cornerRadius: CGFloat
    let githubLink: String
    
    public init(
        secondaryBackground: Color,
        cornerRadius: CGFloat,
        githubLink: String
    ) {
        self.secondaryBackground = secondaryBackground
        self.cornerRadius = cornerRadius
        self.githubLink = githubLink
    }
    
    public var body: some View {
        Link(destination: URL(string: githubLink)!) {
            ListElement() {
                Text("about.github".localisedInBundle(.module))
            }
        }
        .buttonStyle(.borderless)
    }
}

#Preview {
    GitHubLinkButton(secondaryBackground: .blue, cornerRadius: 20, githubLink: "https://www.google.com")
}
