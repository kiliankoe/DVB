//
//  Network.swift
//  Pods
//
//  Created by Kilian Költzsch on 07/05/16.
//
//

import Foundation

//extension DVB {
/**
 Send a GET request.

 - parameter request:    the request to be sent
 - parameter completion: handler provided with a result
 */
func get(request: NSMutableURLRequest, completion: (Result<AnyObject, DVBError>) -> Void) {
    dataTask(request, method: "GET", completion: completion)
}

/**
 Send a NSURLSession dataTask with a given request

 - parameter request:    the request to be sent
 - parameter method:     what HTTP method to use
 - parameter completion: handler provided with a result
 */
private func dataTask(request: NSMutableURLRequest, method: String, completion: (Result<AnyObject, DVBError>) -> Void) {
    request.HTTPMethod = method

    let session = NSURLSession(configuration: .defaultSessionConfiguration())
    session.dataTaskWithRequest(request) { (data, response, error) in

        guard let data = data else {
            completion(.Failure(error: .Request))
            return
        }

        guard 200 ... 299 ~= (response as! NSHTTPURLResponse).statusCode else {
            completion(.Failure(error: .Server(statusCode: (response as! NSHTTPURLResponse).statusCode)))
            return
        }

        let rawJson = try? NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)

        guard let json = rawJson else {
            completion(.Failure(error: .JSON))
            return
        }

        completion(.Success(value: json))
    }.resume()
}
//}
