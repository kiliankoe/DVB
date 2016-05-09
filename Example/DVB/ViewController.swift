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
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true

        DVB.monitor("Helmholtzstraße", limit: 10, line: ["85"]) { (departures) in
            self.departures = departures
            dispatch_async(dispatch_get_main_queue(), {
                [unowned self] in
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                self.tableView.reloadData()
            })
        }
    }

    @IBAction func refreshButtonTapped(sender: UIBarButtonItem) {
        refresh()
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let departures = departures else { return 0 }
        return departures.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("departureCell") ?? UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "departureCell")

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

        return cell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}
