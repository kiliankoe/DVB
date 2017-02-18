//
//  Network.swift
//  Pods
//
//  Created by Kilian Költzsch on 07/05/16.
//
//

import Foundation

func get(_ url: URL, completion: @escaping (Result<Any, DVBError>) -> Void) {
    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    dataTask(request: request, completion: completion)
}

func post(_ url: URL, data: [String: Any], completion: @escaping (Result<Any, DVBError>) -> Void) {
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.httpBody = try? JSONSerialization.data(withJSONObject: data)
    dataTask(request: request, completion: completion)
}

func post<T: FromJSON>(_ url: URL, data: [String: Any], completion: @escaping (Result<T, DVBError>) -> Void) {
    post(url, data: data) { result in
        switch result {
        case .failure(let err):
            completion(.failure(err))
        case .success(let json):
            guard let json = json as? JSON else { completion(.failure(.decode)); return }
            guard let resp = T(json: json) else { completion(.failure(.decode)); return }
            completion(.success(resp))
        }
    }
}

private func dataTask(request: URLRequest, completion: @escaping (Result<Any, DVBError>) -> Void) {
    let session = URLSession(configuration: .default)
    session.dataTask(with: request) { data, response, error in
        guard let data = data else { completion(.failure(.request)); return }

        if let resp = response as? HTTPURLResponse, resp.statusCode / 100 != 2 {
            completion(.failure(.server(statusCode: resp.statusCode)))
            return
        }

        let rawJson = try? JSONSerialization.jsonObject(with: data)

        guard let json = rawJson else { completion(.failure(.decode)); return }

        completion(.success(value: json))
    }.resume()
}
