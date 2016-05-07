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

    var connections: [Connection]?

    override func viewDidLoad() {
        super.viewDidLoad()
        refresh()
    }

    func refresh() {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true

        DVB.monitor("Helmholtzstraße", limit: 10, line: "85") { (connections) in
            self.connections = connections
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
        guard let connections = connections else { return 0 }
        return connections.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("connectionCell") ?? UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "connectionCell")

        guard let connections = connections else { return cell }

        let connection = connections[indexPath.row]

        cell.textLabel?.text = "\(connection.line) \(connection.direction)"

        var detail = ""
        if connection.minutesUntil == 0 {
            detail = "now"
        } else {
            detail = "\(connection.minutesUntil) min"
        }

        cell.detailTextLabel?.text = detail

        return cell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}
