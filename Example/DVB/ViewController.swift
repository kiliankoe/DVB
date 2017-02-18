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

    var departures: [Departure]? {
        didSet {
            DispatchQueue.main.async {
                [weak self] in
                self?.tableView.reloadData()
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        refresh()
    }

    func refresh() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true

        Departure.monitor(id: "33000028") { result in
            switch result {
            case .failure(let error):
                print(error)
                break
            case .success(let response):
                self.departures = response.departures
            }
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
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
//        cell.detailTextLabel?.text = departure.eta == 0 ? "now" : "\(departure.eta) min"
        cell.detailTextLabel?.text = departure.fancyEta
        cell.imageView?.image = UIImage(named: departure.mode.dvbIdentifier)

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
