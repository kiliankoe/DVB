//
//  URL.swift
//  Pods
//
//  Created by Kilian Költzsch on 06/05/16.
//
//

import Foundation

/**
 Listing of all endpoints and their parameters (if any)

 - Monitor:        Monitor a specific stop
 - Haltestelle:
 - Verkehrsmittel:
 */

/**
 Listing of all endpoints and their parameters (if any)

 - Monitor:        Monitor a specific stop
 - Haltestelle:    Find a specific stop
 - Routechanges:   List current route changes
 */
enum URL {
    enum VVO {
        case Monitor(hst: String, vz: Int, ort: String, lim: Int, vm: [TransportMode.Monitor])
        case Haltestelle(hst: String, ort: String)

        func create() -> NSURL {
            switch self {
            case Monitor(let hst, let vz, let ort, let lim, let vm):
                let hst = hst.stringByAddingPercentEncodingWithAllowedCharacters(.URLQueryAllowedCharacterSet())!
                let ort = ort.stringByAddingPercentEncodingWithAllowedCharacters(.URLQueryAllowedCharacterSet())!
                let vmJoined = vm.map { $0.rawValue.stringByAddingPercentEncodingWithAllowedCharacters(.URLQueryAllowedCharacterSet())! }.joinWithSeparator(",")
                return NSURL(string: "http://widgets.vvo-online.de/abfahrtsmonitor/Abfahrten.do?hst=\(hst)&vz=\(vz)&ort=\(ort)&lim=\(lim)&vm=\(vmJoined)")!
            case Haltestelle(let hst, let ort):
                let hst = hst.stringByAddingPercentEncodingWithAllowedCharacters(.URLQueryAllowedCharacterSet())!
                let ort = ort.stringByAddingPercentEncodingWithAllowedCharacters(.URLQueryAllowedCharacterSet())!
                return NSURL(string: "http://widgets.vvo-online.de/abfahrtsmonitor/Haltestelle.do?ort=\(ort)&hst=\(hst)")!
            }
        }
    }

    enum DVB {
        case Routechanges

        func create() -> NSURL {
            switch self {
            case .Routechanges:
                return NSURL(string: "https://www.dvb.de/de-de/apps/routechanges/rssfeed")!
            }
        }
    }

}
