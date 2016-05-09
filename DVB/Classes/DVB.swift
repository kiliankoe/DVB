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
     List all departures from a given stop.

     - parameter stop:       name of the stop
     - parameter city:       optional city, defaults to Dresden
     - parameter line:       optional filter for returning only departures of a specific line or list of lines
     - parameter limit:      optional maximum amount of results, defaults to as many as possible
     - parameter offset:     optional offset for the time until a departure arrives
     - parameter mode:       optional list of modes of transport, defaults to 'normal' things like buses and trams
     - parameter completion: handler provided with list of departures, may be empty if error occurs

     - warning: Even when a `limit` is supplied, you're not guaranteed to receive that many results.
     */
    public static func monitor(stop: String, city: String? = nil, line: [String]? = nil, limit: Int? = nil, offset: Int? = nil, modes: [TransportMode.Monitor]? = nil, completion: ([Departure]) -> Void) {
        let hst = stop
        let vz = offset ?? 0
        let ort = city ?? ""
        let lim = 0
        let vm = modes ?? []
        let request = NSMutableURLRequest(URL: URL.VVO.Monitor(hst: hst, vz: vz, ort: ort, lim: lim, vm: vm).create())

        get(request) { (result) in
            switch result {
            case .Failure(let error):
                print("DVB failed with error: \(error)")
                completion([])
            case .Success(let value):
                guard let departureList = value as? [[String]] else {
                    completion([])
                    return
                }

                // Map Departure structs
                var departures = departureList.map {
                    Departure(line: $0[0], direction: $0[1], minutesUntil: Int($0[2]) ?? 0)
                }

                // Filter out non-requested lines if line filter is set
                if let line = line {
                    departures = departures.filter { return line.contains($0.line) }
                }

                // Return only given limit amount if limit is set
                if var limit = limit {
                    if limit > departures.count {
                        limit = departures.count
                    } else if limit < 0 {
                        limit = 0
                    }
                    departures = Array(departures[0 ..< limit])
                }

                completion(departures)
            }
        }
    }
}
