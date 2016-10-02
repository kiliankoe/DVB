//
//  DVB.swift
//  Pods
//
//  Created by Kilian Költzsch on 06/05/16.
//
//

import Foundation
import Kanna
import MapKit

/// DVB offers static functions to interact with all the different endpoints.
public class DVB {

    /// List all departures from a given stop
    ///
    /// - parameter stop:       name of the stop
    /// - parameter city:       optional city, defaults to Dresden
    /// - parameter line:       optional filter for returning only departures of a specific line or list of lines
    /// - parameter offset:     optional offset for the time until a departure arrives
    /// - parameter modes:      optional list of allowed modes of transport, defaults to 'normal' things like buses and trams
    /// - parameter completion: handler provided with list of departures and optional error
    public static func departures(_ stop: String, city: String = "", line: [String]? = nil, offset: Int = 0, modes: [TransportMode.Departures] = [], completion: @escaping ([Departure], DVBError?) -> Void) {

        let url = URL.VVO.departures(hst: stop, vz: offset, ort: city, lim: 0, vm: modes).url()

        get(url) { (result) in
            switch result {
            case .failure(let error):
                completion([], error)
            case .success(let json):
                guard let list = json as? [Any] else { completion([], .decode); return }
                var departures = list.map(Departure.init).flatMap {$0}

                // Filter out non-requested lines if line filter is set
                if let line = line {
                    departures = departures.filter { return line.contains($0.line) }
                }

                completion(departures, nil)
            }
        }
    }

    /// A list of all stops in the VVO network
    public static var allVVOStops: [Stop] = {
        let dvbBundle = Bundle(for: DVB.self)

        guard let vvostopsPath = dvbBundle.path(forResource: "VVOStops", ofType: "plist"),
        let allStops = NSArray(contentsOfFile: vvostopsPath) as? [[String:AnyObject]] else { return [] }

        var stops = [Stop]()

        for stopElement in allStops {

            // FIXME: Improve on this... A lot!
            let id = (stopElement["id"] as! NSString).integerValue
            let name = stopElement["name"] as! String
            let region = stopElement["region"] as! String
            let searchString = stopElement["searchstring"] as! String
            let tarifZones = stopElement["tarif_zones"] as? String ?? ""
            let longitude = (stopElement["longitude"] as! NSString).doubleValue
            let latitude = (stopElement["latitude"] as! NSString).doubleValue
            let priority = (stopElement["priority"] as! NSString).integerValue

            let stop = Stop(id: id, name: name, region: region, searchString: searchString, tarifZones: tarifZones, longitude: longitude, latitude: latitude, priority: priority)
            stops.append(stop)
        }
        return stops
    }()

    /**
     Find a list of stops with a given search string.

     - parameter searchString: string to search by
     - parameter region:       optional region, defaults to `Dresden`

     - returns: list of stops that match the search string
     */
    public static func find(_ searchString: String, region: String = "Dresden") -> [Stop] {

        let foundStops = self.allVVOStops.filter { stop in
            let nameMatch = stop.searchString.lowercased().contains(searchString.lowercased()) || stop.name.lowercased().contains(searchString.lowercased())
            return nameMatch && stop.region == region
        }

        return foundStops.sorted { $0.priority > $1.priority }
    }

    /**
     Find a list of stops with their distance to a set of coordinates in a given radius. If the search radius is not set, all stops will be returned.

     - parameter latitude:  latitude
     - parameter longitude: longitude
     - parameter radius:    search radius in meters

     - returns: list of stops and their distance from the given coordinates, limited to the search radius if given
     */
    public static func nearestStops(latitude: Double, longitude: Double, radius: Double? = nil) -> [(Stop, Double)] {

        let searchLocation = CLLocation(latitude: latitude, longitude: longitude)

		var stopsWithDistance = [(Stop, Double)]()
		
		for stop in self.allVVOStops {
            guard stop.location.latitude != 999.999999 else { continue } // Some lots have no sane location data :(
            let stopLocation = CLLocation(latitude: stop.location.latitude, longitude: stop.location.longitude)
            let distanceFromSearch = searchLocation.distance(from: stopLocation)
			
			// Add stop with distance, if it's within the search radius or no radius was given
			if let radius = radius , distanceFromSearch <= radius {
				stopsWithDistance.append((stop, distanceFromSearch))
			} else if radius == nil {
				stopsWithDistance.append((stop, distanceFromSearch))
			}
        }
		
		return stopsWithDistance
    }

    /**
     List current route changes in the network.

     - parameter completion: handler provided with a date object when the data was last updated and a list of changes.
     */
    public static func routeChanges(_ completion: @escaping (_ updated: Date?, _ routeChanges: [RouteChange]) -> Void) {

        let request = NSMutableURLRequest(url: URL.DVB.routechanges.create())

        get(request, raw: true) { (result) in
            switch result {
            case .failure(let error):
                print("DVB failed with error: \(error)")
                completion(nil, [])
            case .success(let value):

                guard let value = value as? Data else {
                    completion(nil, [])
                    return
                }

                guard let xml = Kanna.XML(xml: value, encoding: .utf8) else {
                    completion(nil, [])
                    return
                }

                let dateString = xml.at_xpath("//lastBuildDate")?.text
                let updatedDate: Date?

                if let dateString = dateString {
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "E, dd MMMM y HH:mm:ss XX"
                    updatedDate = dateFormatter.date(from: dateString)
                } else {
                    updatedDate = nil
                }

                var items = [RouteChange]()
                for item in xml.xpath("//item") {
                    if let title = item.at_xpath("title")?.text, let details = item.at_xpath("description")?.text {
                        items.append(RouteChange(title: title, rawDetails: details))
                    }
                }

                completion(updatedDate, items)
            }
        }
    }
}
