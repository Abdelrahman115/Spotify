//
//  SearchResult.swift
//  Spotify
//
//  Created by Abdelrahman on 13/05/2023.
//

import Foundation

enum SearchResult{
    case artist(model:Artist)
    case album(model:item)
    case track(model:album)
    case playlist(model:itemOptions)
}
