//
//  Results.swift
//  PlayerTest
//
//  Created by Fernanda de Lima on 18/01/2018.
//  Copyright © 2018 Empresinha. All rights reserved.
//

import AlamofireObjectMapper
import ObjectMapper
import Foundation

class Response: Mappable {
    
    var resultCount: Int?
    var results: [Results]?
    
    required init?(map: Map){
        mapping(map: map)
    }
    
    func mapping(map:Map){
        resultCount      <- map["resultCount"]
        results          <- map["results"]
    }
}

class Results: Mappable {
    
    var artistName: String?
    var trackName: String?
    var previewUrl: String?
    var caminhoLogo: String?
    var artworkUrl100: String?
    var artistViewUrl: String?
    var trackTimeMillis: Int?
    
    required init?(map: Map){
        mapping(map: map)
    }
    
    func mapping(map:Map){
        artistName          <- map["artistName"]
        trackName           <- map["trackName"]
        previewUrl          <- map["previewUrl"]
        artworkUrl100       <- map["artworkUrl100"]
        artistViewUrl       <- map["artistViewUrl"]
        trackTimeMillis     <- map["trackTimeMillis"]
    }
    
    func trackInMinute() -> String{
        if let trackTimeMillis = trackTimeMillis{
            let trackSeconds = Int(trackTimeMillis/1000)
            let minute = Int(trackSeconds/60)
            let seconds = trackSeconds%60
            return "\(minute):\(seconds)"
        }else{
            return "00:00"
        }
    }
    
}

