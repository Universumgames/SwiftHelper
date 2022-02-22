//
//  Bugreport.swift
//  Moody
//
//  Created by Tom Arlt on 08.02.22.
//

import Foundation

public class Bugreport{
    static func reportBug(for app: String, version: String, title: String, description: String, from userMail: String? = nil, to bugreportURL: String) -> Bool{
        
        let link = URL(string: bugreportURL)!
        var request = URLRequest(url: link)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        let parameters: [String: Any] = [
            "app": app,
            "title": title,
            "description": "Inapp report <br> " + description,
            "mail": userMail ?? "not defined",
            "version": version
        ]
        request.httpBody = parameters.percentEncoded()
        
        var errorReturn = false

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data,
                let response = response as? HTTPURLResponse,
                error == nil else {                           // check for fundamental networking error
                print("error", error ?? "Unknown error")
                return
            }

            guard (200 ... 299) ~= response.statusCode else {      // check for http errors
                print("statusCode should be 2xx, but is \(response.statusCode)")
                print("response = \(response)")
                errorReturn = true
                return
            }

            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(responseString ?? "")")
            return
        }

        task.resume()
        return errorReturn
    }
}
