//
//  Network.swift
//  Pods
//
//  Created by Kilian Költzsch on 07/05/16.
//
//

import Foundation

/// Send a GET request
///
/// - parameter url:        URL
/// - parameter raw:        skip JSON deserialization and return raw data instead
/// - parameter completion: handler provided with result
func get(_ url: Foundation.URL, raw: Bool = false, completion: @escaping (Result<Any, DVBError>) -> Void) {
    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    dataTask(request: request, raw: raw, completion: completion)
}

/// Send a NSURLSession dataTask with a given request
///
/// - parameter request:    request to send
/// - parameter raw:        skip JSON deserialization and return raw data instead
/// - parameter completion: handler provided with result
private func dataTask(request: URLRequest, raw: Bool, completion: @escaping (Result<Any, DVBError>) -> Void) {
    let session = URLSession(configuration: .default)
    session.dataTask(with: request) { data, response, error in
        guard let data = data else { completion(.failure(error: .request)); return }

        if let resp = response as? HTTPURLResponse, resp.statusCode / 100 != 2 {
            completion(.failure(error: .server(statusCode: resp.statusCode)))
            return
        }

        if raw {
            completion(.success(value: data))
            return
        }

        let rawJson = try? JSONSerialization.jsonObject(with: data, options: .allowFragments)

        guard let json = rawJson else { completion(.failure(error: .decode)); return }

        completion(.success(value: json))
    }.resume()
}
