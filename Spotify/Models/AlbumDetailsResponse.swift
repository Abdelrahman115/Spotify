//
//  AlbumDetailsResponse.swift
//  Spotify
//
//  Created by Abdelrahman on 07/05/2023.
//

import Foundation

struct AlbumDetailsResponse:Codable{
    let album_type:String
    //let album_group:String
    let total_tracks:Int
    let available_markets:[String]
    let external_urls:[String:String]
    let href:String
    let id:String
    let images:[image]
    let name:String
    let release_date:String
    let release_date_precision:String
    //let restrictions:[String:String]
    let type:String
    let uri:String
    let genres:[String]
    let artists:[Artist]
    let tracks:tracks
    let label:String
    

}

struct tracks:Codable{
    let href:String
    let limit:Int
    //let offset:Bool
    //let previous:String
    let total:Int
    let items:[AlbumDetaisls]
}


struct AlbumDetaisls:Codable{
    let artists:[Artist]
    let available_markets:[String]
    let external_urls:[String:String]
    let href:String
    let id:String
    let disc_number:Int
    let duration_ms:Int
    let name:String
    let type:String
    let track_number:Int
    let preview_url:String?
}


/*
 {
     "album_type" = single;
     artists =     (
                 {
             "external_urls" =             {
                 spotify = "https://open.spotify.com/artist/1TcEy92Hugt8o9STqUDz2D";
             };
             href = "https://api.spotify.com/v1/artists/1TcEy92Hugt8o9STqUDz2D";
             id = 1TcEy92Hugt8o9STqUDz2D;
             name = "Hussain Aljassmi";
             type = artist;
             uri = "spotify:artist:1TcEy92Hugt8o9STqUDz2D";
         }
     );
     "available_markets" =     (
         AD,
         AE,
         AG,
         AL,
         AM,
         AO,
         AR,
         AT,
         AU,
         AZ,
         BA,
         BB,
         BD,
         BE,
         BF,
         BG,
         BH,
         BI,
         BJ,
         BN,
         BO,
         BR,
         BS,
         BT,
         BW,
         BY,
         BZ,
         CA,
         CD,
         CG,
         CH,
         CI,
         CL,
         CM,
         CO,
         CR,
         CV,
         CW,
         CY,
         CZ,
         DE,
         DJ,
         DK,
         DM,
         DO,
         DZ,
         EC,
         EE,
         EG,
         ES,
         ET,
         FI,
         FJ,
         FM,
         FR,
         GA,
         GB,
         GD,
         GE,
         GH,
         GM,
         GN,
         GQ,
         GR,
         GT,
         GW,
         GY,
         HK,
         HN,
         HR,
         HT,
         HU,
         ID,
         IE,
         IL,
         IN,
         IQ,
         IS,
         IT,
         JM,
         JO,
         JP,
         KE,
         KG,
         KH,
         KI,
         KM,
         KN,
         KR,
         KW,
         KZ,
         LA,
         LB,
         LC,
         LI,
         LK,
         LR,
         LS,
         LT,
         LU,
         LV,
         LY,
         MA,
         MC,
         MD,
         ME,
         MG,
         MH,
         MK,
         ML,
         MN,
         MO,
         MR,
         MT,
         MU,
         MV,
         MW,
         MX,
         MY,
         MZ,
         NA,
         NE,
         NG,
         NI,
         NL,
         NO,
         NP,
         NR,
         NZ,
         OM,
         PA,
         PE,
         PG,
         PH,
         PK,
         PL,
         PS,
         PT,
         PW,
         PY,
         QA,
         RO,
         RS,
         RW,
         SA,
         SB,
         SC,
         SE,
         SG,
         SI,
         SK,
         SL,
         SM,
         SN,
         SR,
         ST,
         SV,
         SZ,
         TD,
         TG,
         TH,
         TJ,
         TL,
         TN,
         TO,
         TR,
         TT,
         TV,
         TW,
         TZ,
         UA,
         UG,
         US,
         UY,
         UZ,
         VC,
         VE,
         VN,
         VU,
         WS,
         XK,
         ZA,
         ZM,
         ZW
     );
     copyrights =     (
                 {
             text = "2023 Hussain Al Jassmi";
             type = C;
         },
                 {
             text = "2023 Hussain Al Jassmi";
             type = P;
         }
     );
     "external_ids" =     {
         upc = 889502449094;
     };
     "external_urls" =     {
         spotify = "https://open.spotify.com/album/3vUNaafLFHeKUOdDzM73O9";
     };
     genres =     (
     );
     href = "https://api.spotify.com/v1/albums/3vUNaafLFHeKUOdDzM73O9";
     id = 3vUNaafLFHeKUOdDzM73O9;
     images =     (
                 {
             height = 640;
             url = "https://i.scdn.co/image/ab67616d0000b273fe4b1f2a2f0a5cd313b2e630";
             width = 640;
         },
                 {
             height = 300;
             url = "https://i.scdn.co/image/ab67616d00001e02fe4b1f2a2f0a5cd313b2e630";
             width = 300;
         },
                 {
             height = 64;
             url = "https://i.scdn.co/image/ab67616d00004851fe4b1f2a2f0a5cd313b2e630";
             width = 64;
         }
     );
     label = "Hussain Al Jassmi";
     name = "Ya Khabar";
     popularity = 23;
     "release_date" = "2023-05-11";
     "release_date_precision" = day;
     "total_tracks" = 1;
     tracks =     {
         href = "https://api.spotify.com/v1/albums/3vUNaafLFHeKUOdDzM73O9/tracks?offset=0&limit=50&locale=en-US,en;q=0.9";
         items =         (
                         {
                 artists =                 (
                                         {
                         "external_urls" =                         {
                             spotify = "https://open.spotify.com/artist/1TcEy92Hugt8o9STqUDz2D";
                         };
                         href = "https://api.spotify.com/v1/artists/1TcEy92Hugt8o9STqUDz2D";
                         id = 1TcEy92Hugt8o9STqUDz2D;
                         name = "Hussain Aljassmi";
                         type = artist;
                         uri = "spotify:artist:1TcEy92Hugt8o9STqUDz2D";
                     }
                 );
                 "available_markets" =                 (
                     AR,
                     AU,
                     AT,
                     BE,
                     BO,
                     BR,
                     BG,
                     CA,
                     CL,
                     CO,
                     CR,
                     CY,
                     CZ,
                     DK,
                     DO,
                     DE,
                     EC,
                     EE,
                     SV,
                     FI,
                     FR,
                     GR,
                     GT,
                     HN,
                     HK,
                     HU,
                     IS,
                     IE,
                     IT,
                     LV,
                     LT,
                     LU,
                     MY,
                     MT,
                     MX,
                     NL,
                     NZ,
                     NI,
                     NO,
                     PA,
                     PY,
                     PE,
                     PH,
                     PL,
                     PT,
                     SG,
                     SK,
                     ES,
                     SE,
                     CH,
                     TW,
                     TR,
                     UY,
                     US,
                     GB,
                     AD,
                     LI,
                     MC,
                     ID,
                     JP,
                     TH,
                     VN,
                     RO,
                     IL,
                     ZA,
                     SA,
                     AE,
                     BH,
                     QA,
                     OM,
                     KW,
                     EG,
                     MA,
                     DZ,
                     TN,
                     LB,
                     JO,
                     PS,
                     IN,
                     BY,
                     KZ,
                     MD,
                     UA,
                     AL,
                     BA,
                     HR,
                     ME,
                     MK,
                     RS,
                     SI,
                     KR,
                     BD,
                     PK,
                     LK,
                     GH,
                     KE,
                     NG,
                     TZ,
                     UG,
                     AG,
                     AM,
                     BS,
                     BB,
                     BZ,
                     BT,
                     BW,
                     BF,
                     CV,
                     CW,
                     DM,
                     FJ,
                     GM,
                     GE,
                     GD,
                     GW,
                     GY,
                     HT,
                     JM,
                     KI,
                     LS,
                     LR,
                     MW,
                     MV,
                     ML,
                     MH,
                     FM,
                     NA,
                     NR,
                     NE,
                     PW,
                     PG,
                     WS,
                     SM,
                     ST,
                     SN,
                     SC,
                     SL,
                     SB,
                     KN,
                     LC,
                     VC,
                     SR,
                     TL,
                     TO,
                     TT,
                     TV,
                     VU,
                     AZ,
                     BN,
                     BI,
                     KH,
                     CM,
                     TD,
                     KM,
                     GQ,
                     SZ,
                     GA,
                     GN,
                     KG,
                     LA,
                     MO,
                     MR,
                     MN,
                     NP,
                     RW,
                     TG,
                     UZ,
                     ZW,
                     BJ,
                     MG,
                     MU,
                     MZ,
                     AO,
                     CI,
                     DJ,
                     ZM,
                     CD,
                     CG,
                     IQ,
                     LY,
                     TJ,
                     VE,
                     ET,
                     XK
                 );
                 "disc_number" = 1;
                 "duration_ms" = 172711;
                 explicit = 0;
                 "external_urls" =                 {
                     spotify = "https://open.spotify.com/track/3FQFEFkm0aRQOTez0p5rrU";
                 };
                 href = "https://api.spotify.com/v1/tracks/3FQFEFkm0aRQOTez0p5rrU";
                 id = 3FQFEFkm0aRQOTez0p5rrU;
                 "is_local" = 0;
                 name = "Ya Khabar";
                 "preview_url" = "https://p.scdn.co/mp3-preview/6a2d4709a1c3b19f258e2d78df87a9ddae50cafd?cid=64526f85532447a89febc23fcf3a0e2c";
                 "track_number" = 1;
                 type = track;
                 uri = "spotify:track:3FQFEFkm0aRQOTez0p5rrU";
             }
         );
         limit = 50;
         next = "<null>";
         offset = 0;
         previous = "<null>";
         total = 1;
     };
     type = album;
     uri = "spotify:album:3vUNaafLFHeKUOdDzM73O9";
 }
 
 */



