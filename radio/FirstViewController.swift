//
//  FirstViewController.swift
//  radio
//
//  Created by segler on 17.03.17.
//  Copyright © 2017 segler. All rights reserved.
//

import UIKit
import AVFoundation

class FirstViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var stations: [RadioStation] = []
    @IBOutlet var tblStations: UITableView!
    
    var player: AVPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        print("Start..")
        downloadMgr.makeGetCall(path: "/webservice/json/stations/topclick/100", cb: cb)
    }
    
    func cb(stations: [RadioStation]){
        DispatchQueue.main.async {
            self.stations = stations
            self.tblStations.reloadData()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stations.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: "")
        
        cell.textLabel?.text = stations[indexPath.row].name
        cell.detailTextLabel?.text = stations[indexPath.row].tags
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        let station = stations[indexPath.row]
        print("click on " + station.name)
        play(urlStr: station.url)
    }
    
    func play(urlStr: String){
        do{
            let url = URL(string: urlStr)
            print("#1")
            let item = AVPlayerItem(url: url!)
            player = AVPlayer(playerItem: item)
            print("#2");
            guard let player = player else {
                print("player error")
                return
            }
            print("#3");
            player.volume = 1
            player.play()
        }
        catch let error{
            print(error.localizedDescription)
        }
    }
}

