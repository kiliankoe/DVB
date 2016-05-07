//
//  DVB.swift
//  Pods
//
//  Created by Kilian Költzsch on 06/05/16.
//
//

import Foundation

/// DVB offers static functions to interact with all the different endpoints.
public class DVB {

    /**
     List all connections from a given stop.

     - parameter stop:       name of the stop
     - parameter city:       optional city, defaults to Dresden
     - parameter line:       optional filter for returning only connections of a specific line
     - parameter limit:      optional maximum amount of results, defaults to as many as possible
     - parameter offset:     optional offset for the time until a connection arrives
     - parameter mode:       optional list of modes of transport, defaults to 'normal' things like buses and trams
     - parameter completion: handler provided with list of connections, may be empty if error occurs

     - warning: Even when a `limit` is supplied, you're not guaranteed to receive that many results.
     */
    public static func monitor(stop: String, city: String? = nil, line: String? = nil, limit: Int? = nil, offset: Int? = nil, mode: [TransportMode]? = nil, completion: ([Connection]) -> Void) {
        let hst = stop
        let vz = offset ?? 0
        let ort = city ?? ""
        let lim = 0
        let vm = mode ?? []
        let request = NSMutableURLRequest(URL: URL.VVO.Monitor(hst: hst, vz: vz, ort: ort, lim: lim, vm: vm).create())

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
                if var limit = limit {
                    if limit > connections.count {
                        limit = connections.count
                    } else if limit < 0 {
                        limit = 0
                    }
                    connections = Array(connections[0 ..< limit])
                }

                completion(connections)
            }
        }
    }
}
