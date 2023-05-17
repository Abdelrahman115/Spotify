//
//  FeaturedPlaylist.swift
//  Spotify
//
//  Created by Abdelrahman on 03/05/2023.
//

import Foundation

struct FeaturedPlaylist:Codable{
    let message:String
    let playlists:playlist
}

struct playlist:Codable{
    let href:String
    let items:[itemOptions]
    let limit:Int?
    let next:String?
    let offset:Int?
    let previous:String?
    let total:Int?
}




struct itemOptions:Codable{
    let collaborative:Bool
    let description:String?
    let external_urls:[String:String]
    let href:String
    let id:String
    let images:[image]
    let name:String
    let owner:owner
    let snapshot_id:String
    let tracks:track
    let type:String
    let uri:String
    
}


struct owner:Codable{
    let display_name:String
    let external_urls:[String:String]
    let href:String
    let id:String?
    let type:String
    let uri:String
}

struct track:Codable{
    let href:String
    let total:Int?
}



/*
 collaborative = 0;
 description = "<null>";
 "external_urls" =     {
     spotify = "https://open.spotify.com/playlist/7kVGFDt8TctD6ZqkUS5qXH";
 };
 followers =     {
     href = "<null>";
     total = 0;
 };
 href = "https://api.spotify.com/v1/playlists/7kVGFDt8TctD6ZqkUS5qXH";
 id = 7kVGFDt8TctD6ZqkUS5qXH;
 images =     (
 );
 name = newPlaylist;
 owner =     {
     "display_name" = Tharwat;
     "external_urls" =         {
         spotify = "https://open.spotify.com/user/o564056qlnzzrc20q095m2bpv";
     };
     href = "https://api.spotify.com/v1/users/o564056qlnzzrc20q095m2bpv";
     id = o564056qlnzzrc20q095m2bpv;
     type = user;
     uri = "spotify:user:o564056qlnzzrc20q095m2bpv";
 };
 "primary_color" = "<null>";
 public = 1;
 "snapshot_id" = MSxlY2M0Y2IzNzAxMzk3NTJjM2RlYTE0ZDgzMDVhNjA4NGNkOGVmMTJj;
 tracks =     {
     href = "https://api.spotify.com/v1/playlists/7kVGFDt8TctD6ZqkUS5qXH/tracks";
     items =         (
     );
     limit = 100;
     next = "<null>";
     offset = 0;
     previous = "<null>";
     total = 0;
 };
 type = playlist;
 uri = "spotify:playlist:7kVGFDt8TctD6ZqkUS5qXH";
}
 
 
 */


