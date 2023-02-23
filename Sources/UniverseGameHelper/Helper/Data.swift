//
//  File.swift
//  
//
//  Created by Tom Arlt on 23.02.23.
//

import Foundation

public extension Data {
    var prettyPrintedJSONString: NSString? { /// NSString gives us a nice sanitized debugDescription
        guard let object = try? JSONSerialization.jsonObject(with: self, options: []),
              let data = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted]),
              let prettyPrintedString = NSString(data: data, encoding: String.Encoding.utf8.rawValue) else { return nil }

        return prettyPrintedString
    }

    func toString(_ encoding: String.Encoding = .utf8) -> String? {
        return String(data: self, encoding: encoding)
    }
    
    func toStringOrEmpty(_ encoding: String.Encoding = .utf8) -> String {
        return toString(encoding) ?? ""
    }
}
