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
 - parameter raw:        bool flag that if true ensures raw data and not JSON to be returned
 - parameter completion: handler provided with a result
 */
func get(_ request: NSMutableURLRequest, raw: Bool = false, completion: @escaping (Result<Any, DVBError>) -> Void) {
    dataTask(request, method: "GET", raw: raw, completion: completion)
}

/**
 Send a NSURLSession dataTask with a given request

 - parameter request:    the request to be sent
 - parameter method:     what HTTP method to use
 - parameter raw:        bool flag that if true ensures raw data and not JSON to be returned
 - parameter completion: handler provided with a result
 */
private func dataTask(_ request: NSMutableURLRequest, method: String, raw: Bool, completion: @escaping (Result<Any, DVBError>) -> Void) {
    var request = request as URLRequest
    request.httpMethod = method

    let session = URLSession(configuration: .default)
    session.dataTask(with: request) { data, response, error in
        guard let data = data else {
            completion(.failure(error: .request))
            return
        }

        guard 200 ... 299 ~= (response as! HTTPURLResponse).statusCode else {
            completion(.failure(error: .server(statusCode: (response as! HTTPURLResponse).statusCode)))
            return
        }

        if raw {
            completion(.success(value: data))
            return
        }

        let rawJson = try? JSONSerialization.jsonObject(with: data, options: .allowFragments)

        guard let json = rawJson else {
            completion(.failure(error: .json))
            return
        }

        completion(.success(value: json))
    }.resume()
}
