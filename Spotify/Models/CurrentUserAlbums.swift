//
//  CurrentUserAlbums.swift
//  Spotify
//
//  Created by Abdelrahman on 16/05/2023.
//

import Foundation


struct CurrentUserAlbumsResponse:Codable{
    let href:String
    let items:[userAlbums]
}


struct userAlbums:Codable{
    let added_at:String
    let album:item
}





