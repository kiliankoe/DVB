//
//  URL.swift
//  Pods
//
//  Created by Kilian Költzsch on 06/05/16.
//
//

import Foundation

/// Listing of all endpoints and their parameters (if any)
///
/// - abfahrten:    Departures from a stop
/// - haltestelle:  Find a stop
/// - routechanges: List current route changes
enum URL {
    enum VVO {
        case departures(hst: String, vz: Int, ort: String, lim: Int, vm: [TransportMode.Departure])
        case stop(hst: String, ort: String)

        func url() -> Foundation.URL {
            let widgetsBase = Foundation.URL(string: "http://widgets.vvo-online.de/abfahrtsmonitor/")

            switch self {
            case .departures(let hst, let vz, let ort, let lim, let vm):
                let hst = hst.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
                let ort = ort.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
                let vmJoined = vm.map { $0.rawValue.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)! }.joined(separator: ",")
                return Foundation.URL(string: "Abfahrten.do?hst=\(hst)&vz=\(vz)&ort=\(ort)&lim=\(lim)&vm=\(vmJoined)", relativeTo: widgetsBase)!
            case .stop(let hst, let ort):
                let hst = hst.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
                let ort = ort.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
                return Foundation.URL(string: "Haltestelle.do?ort=\(ort)&hst=\(hst)", relativeTo: widgetsBase)!
            }
        }
    }

    enum DVB {
        case routechanges

        func url() -> Foundation.URL {
            switch self {
            case .routechanges:
                return Foundation.URL(string: "https://www.dvb.de/de-de/apps/routechanges/rssfeed")!
            }
        }
    }

}
