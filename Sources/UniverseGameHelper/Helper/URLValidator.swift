//
//  URLValidator.swift
//  VideoConferenceManager
//
//  Created by Tom Arlt on 27.11.21.
//

import Foundation
import UIKit

func verifyUrl(urlString: String?) -> Bool {
    if let urlString = urlString {
        if let url = NSURL(string: urlString) {
            return UIApplication.shared.canOpenURL(url as URL)
        }
    }
    return false
}

func fixBrowserURL(url: String) -> String {
    return url
}

