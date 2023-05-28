//
//  WifiListViewer.swift
//  ImageFinal
//
//  Created by sang on 28/5/23.
//

import UIKit
import CoreBluetooth
import SystemConfiguration.CaptiveNetwork
import NetworkExtension




class WifiListViewer: UIViewController , UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tabelView: UITableView!
    var wifiNetworks: [NEHotspotNetwork] = [] // Array to store Wi-Fi network names
    override func viewDidLoad() {
        super.viewDidLoad()

        
        tabelView.dataSource = self
              
              fetchWifiNetworks() // Fetch Wi-Fi networks
          }
          
          func fetchWifiNetworks() {
              NEHotspotHelper.register(options: nil, queue: DispatchQueue.main) { [weak self] (command) in
                          guard let strongSelf = self else { return }
                          
                          if let networks = command.networkList {
                              strongSelf.wifiNetworks = networks
                              DispatchQueue.main.async {
                                  strongSelf.tabelView.reloadData() // Reload the table view data
                              }
                          }
                      }
          }
          
          func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
              return wifiNetworks.count
              print(wifiNetworks.count)
          }
          
          func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
              let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
             
              return cell
          }
      
 

}
