//
//  SettingsModels.swift
//  Spotify
//
//  Created by Abdelrahman on 03/05/2023.
//

import Foundation


struct Section{
    let title:String
    let options:[Option]
}

struct Option{
    let title:String
    let handler:() -> Void
}
