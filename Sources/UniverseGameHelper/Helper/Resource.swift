//
//  Resource.swift
//  Moody
//
//  Created by Tom Arlt on 16.02.22.
//

import Foundation

public class Resource {
    func loadResource(filename: String, fileEnding: String) -> String? {
        if let fileURL = Bundle.main.url(forResource: filename, withExtension: fileEnding) {
            if let fileContents = try? String(contentsOf: fileURL) {
                return fileContents
            }
        }
        return nil
    }
}
