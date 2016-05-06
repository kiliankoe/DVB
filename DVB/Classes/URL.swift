//
//  URL.swift
//  Pods
//
//  Created by Kilian Költzsch on 06/05/16.
//
//

import Foundation

enum URL {
    enum VVO {
        case Monitor(hst: String, vz: Int, ort: String, lim: Int)
        case Haltestelle(hst: String, ort: String)

        func create() -> NSURL {
            switch self {
            case Monitor(let hst, let vz, let ort, let lim):
                let hst = hst.stringByAddingPercentEncodingWithAllowedCharacters(.URLQueryAllowedCharacterSet())!
                let ort = ort.stringByAddingPercentEncodingWithAllowedCharacters(.URLQueryAllowedCharacterSet())!
                return NSURL(string: "http://widgets.vvo-online.de/abfahrtsmonitor/Abfahrten.do?hst=\(hst)&vz=\(vz)&ort=\(ort)&lim=\(lim)")!
            case Haltestelle(let hst, let ort):
                let hst = hst.stringByAddingPercentEncodingWithAllowedCharacters(.URLQueryAllowedCharacterSet())!
                let ort = ort.stringByAddingPercentEncodingWithAllowedCharacters(.URLQueryAllowedCharacterSet())!
                return NSURL(string: "http://widgets.vvo-online.de/abfahrtsmonitor/Haltestelle.do?ort=\(ort)&hst=\(hst)")!
            }
        }
    }

}
