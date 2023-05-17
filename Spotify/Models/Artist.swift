//
//  Artist.swift
//  Spotify
//
//  Created by Abdelrahman on 02/05/2023.
//

import Foundation

struct Artist:Codable{
    let external_urls:[String:String]
    let href:String
    let id:String
    let name:String
    let type:String
    let uri:String
    let genres:[String]?
    let images:[image]?
    
}
