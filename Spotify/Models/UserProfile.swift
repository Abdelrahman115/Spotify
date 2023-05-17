//
//  UserProfile.swift
//  Spotify
//
//  Created by Abdelrahman on 02/05/2023.
//

import Foundation


struct UserProfile:Codable{
    let country:String
    let display_name:String
    let email:String
    let explicit_content:[String:Bool]
    let external_urls:[String:String]
    //let followers:[String:AnyObject]
    let href:String
    let id:String
    let images:[images]?
    let product:String
    let type:String
    let uri:String
}





struct followers:Codable{
    let href:String
    let total:Int
}
struct images:Codable{
    let url:String
    //let height:String
    //let width:String
}

