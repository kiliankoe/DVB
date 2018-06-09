import Foundation

typealias JSON = [String: Any]

func get<T: Decodable>(_ url: URL,
                       session: URLSession = .shared,
                       completion: @escaping (Result<T>) -> Void) {
    var request = URLRequest(url: url)
    request.httpMethod = HTTPMethod.GET.rawValue
    dataTask(request: request, session: session, completion: completion)
}

func post<T: Decodable, U: Encodable>(_ url: URL,
                                      data: U,
                                      session: URLSession = .shared,
                                      completion: @escaping (Result<T>) -> Void) {
    do {
        let encoder = JSONEncoder()
        //        encoder.dateEncodingStrategy = .custom(SAPDateEncoder.strategy) // TODO:
        let data = try encoder.encode(data)
        _post(url, data: data, session: session, completion: completion)
    } catch let error {
        completion(Result(failure: error))
        return
    }
}

func post<T: Decodable>(_ url: URL,
                        data: [String: Any],
                        session: URLSession = .shared,
                        completion: @escaping (Result<T>) -> Void) {
    do {
        let data = try JSONSerialization.data(withJSONObject: data)
        _post(url, data: data, session: session, completion: completion)
    } catch let error {
        completion(Result(failure: error))
        return
    }
}

//swiftlint:disable:next identifier_name
func _post<T: Decodable>(_ url: URL,
                         data: Data,
                         session: URLSession,
                         completion: @escaping (Result<T>) -> Void) {
    var request = URLRequest(url: url)
    request.httpMethod = HTTPMethod.POST.rawValue
    request.addValue("application/json;charset=UTF-8", forHTTPHeaderField: "Content-Type")
    request.httpBody = data

    dataTask(request: request, session: session, completion: completion)
}

private enum HTTPMethod: String {
    case GET
    case POST
}

private func dataTask<T: Decodable>(request: URLRequest,
                                    session: URLSession = .shared,
                                    completion: @escaping (Result<T>) -> Void) {
    let task = session.dataTask(with: request) { data, response, error in
        guard
            error == nil,
            let data = data,
            let response = response as? HTTPURLResponse
        else {
            completion(Result(failure: DVBError.network))
            return
        }

        guard response.statusCode / 100 == 2 else {
            completion(Result(failure: DVBError.server(statusCode: response.statusCode)))
            return
        }

        do {
            guard let json = try JSONSerialization.jsonObject(with: data) as? JSON else {
                completion(Result(failure: DVBError.decode))
                return
            }

            guard
                let status = json["Status"] as? JSON,
                let statusCode = status["Code"] as? String
            else {
                completion(Result(failure: DVBError.response))
                return
            }

            guard statusCode == "Ok" else {
                var message = ""
                if let messageTxt = status["Message"] as? String {
                    message = messageTxt
                }
                completion(Result(failure: DVBError.request(status: statusCode, message: message)))
                return
            }

            let jsonDecoder = JSONDecoder()
            jsonDecoder.dateDecodingStrategy = .custom(SAPDateDecoder.strategy)
            let decoded = try jsonDecoder.decode(T.self, from: data)
            completion(Result(success: decoded))

        } catch let error {
            completion(Result(failure: error))
        }
    }
    task.resume()
}
