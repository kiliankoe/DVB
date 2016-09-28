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

 - monitor:        Monitor a specific stop
 - haltestelle:    Find a specific stop
 - routechanges:   List current route changes
 */
enum URL {
    enum VVO {
        case monitor(hst: String, vz: Int, ort: String, lim: Int, vm: [TransportMode.Monitor])
        case haltestelle(hst: String, ort: String)

        func create() -> Foundation.URL {
            switch self {
            case .monitor(let hst, let vz, let ort, let lim, let vm):
                let hst = hst.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
                let ort = ort.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
                let vmJoined = vm.map { $0.rawValue.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)! }.joined(separator: ",")
                return Foundation.URL(string: "http://widgets.vvo-online.de/abfahrtsmonitor/Abfahrten.do?hst=\(hst)&vz=\(vz)&ort=\(ort)&lim=\(lim)&vm=\(vmJoined)")!
            case .haltestelle(let hst, let ort):
                let hst = hst.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
                let ort = ort.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
                return Foundation.URL(string: "http://widgets.vvo-online.de/abfahrtsmonitor/Haltestelle.do?ort=\(ort)&hst=\(hst)")!
            }
        }
    }

    enum DVB {
        case routechanges

        func create() -> Foundation.URL {
            switch self {
            case .routechanges:
                return Foundation.URL(string: "https://www.dvb.de/de-de/apps/routechanges/rssfeed")!
            }
        }
    }

}
