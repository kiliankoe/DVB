//
//  ViewController.swift
//  DVB
//
//  Created by Kilian Koeltzsch on 05/06/2016.
//  Copyright (c) 2016 Kilian Koeltzsch. All rights reserved.
//

import UIKit
import DVB

class ViewController: UITableViewController {

    var departures: [Departure]?

    override func viewDidLoad() {
        super.viewDidLoad()
        refresh()
    }

    func refresh() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true

        DVB.monitor("Albertplatz") { (departures) in
            self.departures = departures
            DispatchQueue.main.async {
                [unowned self] in
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                self.tableView.reloadData()
            }
        }
    }

    @IBAction func refreshButtonTapped(_ sender: UIBarButtonItem) {
        refresh()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let departures = departures else { return 0 }
        return departures.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "departureCell") ?? UITableViewCell(style: UITableViewCellStyle.value1, reuseIdentifier: "departureCell")

        guard let departures = departures else { return cell }

        let departure = departures[indexPath.row]

        cell.textLabel?.text = "\(departure.line) \(departure.direction)"

        var detail = ""
        if departure.minutesUntil == 0 {
            detail = "now"
        } else {
            detail = "\(departure.minutesUntil) min"
        }

        cell.detailTextLabel?.text = detail

        if let typeID = departure.type?.identifier {
            cell.imageView?.image = UIImage(named: typeID)
        }

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
