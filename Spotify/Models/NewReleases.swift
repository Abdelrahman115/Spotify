//
//  NewReleases.swift
//  Spotify
//
//  Created by Abdelrahman on 03/05/2023.
//

import Foundation


struct NewReleasesResponse:Codable{
    let albums:albums
}



struct albums:Codable{
    let href:String
    let limit:Int?
    let next:String?
    let offset:Int?
    let previous:String?
    let total:Int?
    let items:[item]
}

struct item:Codable{
    let album_type:String?
    //let album_group:String
    let artists:[Artist]
    let available_markets:[String]
    let external_urls:[String:String]
    let href:String
    let id:String
    let images:[image]
    let name:String
    let release_date:String
    let release_date_precision:String
    let total_tracks:Int
    let type:String
    let uri:String
}


struct image:Codable{
    let url:String?
    let height:Int?
    let width:Int?
}



