import Foundation
import DVB

DVB.departures("Postplatz") { departures, error in
  guard error == nil else { print("Couldn't get departure list: \(error!)"); return }
  for departure in departures {
    print(departure)
  }
}

let stops = DVB.find(query: "Zellesch")
print(stops)

let closeStops = DVB.findNear(latitude: 51.0271761, longitude: 13.7258114, radius: 300)
print(closeStops)

DVB.routeChanges { updated, routeChanges, error in
    guard error == nil else { print("Couldn't get route changes: \(error)"); return }
    print(updated)
    print(routeChanges)
}
