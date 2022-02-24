//
//  URLValidator.swift
//  VideoConferenceManager
//
//  Created by Tom Arlt on 27.11.21.
//

import Foundation
import UIKit

public func verifyUrl(urlString: String?) -> Bool {
    if let urlString = urlString {
        if let url = NSURL(string: urlString) {
            return UIApplication.shared.canOpenURL(url as URL)
        }
    }
    return false
}

public func fixBrowserURL(url: String) -> String {
    let lowerCase = url.lowercased()
    if lowerCase.starts(with: "http://") || lowerCase.starts(with: "https://") {
        return "https://" + url
    }
    return url
}
