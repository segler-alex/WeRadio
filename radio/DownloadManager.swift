//
//  Downloader.swift
//  radio
//
//  Created by segler on 26.03.17.
//  Copyright © 2017 segler. All rights reserved.
//

import Foundation

struct RadioStation {
    var name = ""
    var url = ""
    var tags = ""
}

var downloadMgr: DownloadManager = DownloadManager()

class DownloadManager : NSObject{
    func makeGetCall(path: String, cb: @escaping ([RadioStation]) -> ()) {
        var stationsList = [RadioStation]()

        // Set up the URL request
        let todoEndpoint: String = "https://www.radio-browser.info" + path
        guard let url = URL(string: todoEndpoint) else {
            print("Error: cannot create URL")
            return
        }
        let urlRequest = URLRequest(url: url)
        
        // set up the session
        let config = URLSessionConfiguration.default
        let additionalHeadersDict = ["User-Agent": "WeRadio/0.1.0"]
        config.httpAdditionalHeaders = additionalHeadersDict
        let session = URLSession(configuration: config)
        
        // make the request
        let task = session.dataTask(with: urlRequest) {
            (data, response, error) in
            // check for any errors
            guard error == nil else {
                print("error calling GET on /todos/1")
                print(error)
                return
            }
            // make sure we got data
            guard let responseData = data else {
                print("Error: did not receive data")
                return
            }
            //let s1 = String(data:responseData, encoding: String.Encoding.utf8)
            // parse the result as JSON, since that's what the API provides
            do {
                let stationsObj = try JSONSerialization.jsonObject(with: responseData, options: JSONSerialization.ReadingOptions.allowFragments)
                if let stations = stationsObj as? [Any] {
                    for stationObj in stations {
                        if let station = stationObj as? [String: String] {
                            let name = station["name"] ?? ""
                            let url = station["url"] ?? ""
                            let tags = station["tags"] ?? ""
                            stationsList.append(RadioStation(name:name,url:url,tags:tags))
                        }
                    }
                }
            } catch  {
                print("error trying to convert data to JSON 2")
                return
            }
            
            cb(stationsList)
        }
        
        task.resume()
    }
}
