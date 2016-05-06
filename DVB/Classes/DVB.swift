//
//  DVB.swift
//  Pods
//
//  Created by Kilian Költzsch on 06/05/16.
//
//

import Foundation

/// DVB offers static functions to interact with all the different endpoints
public class DVB {

    /**
     List all connections from a given stop

     - parameter stop:       name of the stop
     - parameter city:       optional city, defaults to Dresden
     - parameter line:       optional filter for returning only connections of a specific line
     - parameter limit:      optional maximum amount of results, defaults to as many as possible
     - parameter offset:     optional offset for the time until a connection arrives
     - parameter completion: handler provided with list of connections, may be empty if error occurs

     - warning: Even when a `limit` is supplied, you're not guaranteed to receive that many results
     */
    public static func monitor(stop: String, city: String? = nil, line: String? = nil, limit: Int? = nil, offset: Int? = nil, completion: ([Connection]) -> Void) {
        let hst = stop
        let vz = offset ?? 0
        let ort = city ?? ""
        let lim = 0
        let request = NSMutableURLRequest(URL: URL.VVO.Monitor(hst: hst, vz: vz, ort: ort, lim: lim).create())

        get(request) { (result) in
            switch result {
            case .Failure(let error):
                print(error)
                completion([])
            case .Success(let value):
                guard let connectionList = value as? [[String]] else {
                    completion([])
                    return
                }

                // Map Connections structs
                var connections = connectionList.map {
                    Connection(line: $0[0], direction: $0[1], minutesUntil: Int($0[2]) ?? 0)
                }

                // Filter out wrong lines if line filter is set
                if let line = line {
                    connections = connections.filter { return $0.line == line }
                }

                // Return only given limit amount if limit is set
                if let limit = limit {
                    connections = Array(connections[0 ..< limit])
                }

                completion(connections)
            }
        }
    }

    /**
     Send a GET request

     - parameter request:    the request to be sent
     - parameter completion: handler provided with a result
     */
    static private func get(request: NSMutableURLRequest, completion: (Result<AnyObject, DVBError>) -> Void) {
        dataTask(request, method: "GET", completion: completion)
    }

    /**
     Send a NSURLSession dataTask with a given request

     - parameter request:    the request to be sent
     - parameter method:     what HTTP method to use
     - parameter completion: handler provided with a result
     */
    static private func dataTask(request: NSMutableURLRequest, method: String, completion: (Result<AnyObject, DVBError>) -> Void) {
        request.HTTPMethod = method

        let session = NSURLSession(configuration: .defaultSessionConfiguration())
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        session.dataTaskWithRequest(request) { (data, response, error) in
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
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
}

/**
 Error type used by DVB

 - Request: There's something wrong with the request being sent
 - Server:  The server returned an error or no data, statusCode is included in error
 - JSON:    The returned JSON data is malformed
 */
enum DVBError: ErrorType {
    case Request
    case Server(statusCode: Int)
    case JSON
}

enum Result<T, E: ErrorType> {
    case Success(value: T)
    case Failure(error: E)
}
