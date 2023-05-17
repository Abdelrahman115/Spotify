//
//  FetchHomeData.swift
//  Spotify
//
//  Created by Abdelrahman on 07/05/2023.
//

import Foundation
import UIKit

class FetchHomeData{
    static var newAlbums:[item] = []
    static var track:[AudioTrack] = []
    static var playlist:[itemOptions] = []
    var bindNewReleasesToHomeView:(() -> ()) = {}
    var bindPlaylistsToHomeView:(() -> ()) = {}
    var bindRecommendationsToHomeView:(() -> ()) = {}
    var bindProfileToHomeView:(() -> ()) = {}
    var newReleases:NewReleasesResponse?{
        didSet{
            bindNewReleasesToHomeView()
        }
    }
    var featuredPlaylist:FeaturedPlaylist?{
        didSet{
            bindPlaylistsToHomeView()
        }
    }
    var recommendations:RecommendationsResponse?{
        didSet{
            bindRecommendationsToHomeView()
        }
    }
    var profile:UserProfile?{
        didSet{
            bindProfileToHomeView()
        }
    }

    
    //static var sections = [BrowseSectionType]()
    
    func fetchData(collectionView:UICollectionView){
        let group = DispatchGroup()
        group.enter()
        group.enter()
        group.enter()
        APICaller.shared.getNewReleases { /*[weak self]*/ result in
            defer{
                group.leave()
            }
            switch result{
            case .success(let model):
                self.newReleases = model
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
        //FeaturedPlayList
        APICaller.shared.getFeaturedPlaylists { result in
            defer{
                group.leave()
            }
            switch result{
            case.success(let model):
                self.featuredPlaylist = model
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
        //Recommendations
        APICaller.shared.getRecommendationsGenres { result in
            switch result{
            case.success(let model):
                let genres = model.genres
                var seeds = Set<String>()
                while seeds.count<5{
                    if let random = genres.randomElement(){
                        seeds.insert(random)
                        
                    }
                }
                APICaller.shared.getRecommendations(genres: seeds){ result in
                    defer{
                        group.leave()
                    }
                    switch result{
                    case.success(let model):
                        self.recommendations = model
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        

    }
    
    func fetchProfile(){
        APICaller.shared.getCurrentUserProfile { [weak self] result in
            switch result{
            case.success(let model):
                DispatchQueue.main.async {
                    self?.profile = model
                }
            case.failure(let error):
                DispatchQueue.main.async {
                    print(error.localizedDescription)
                    //self?.failedToGetProfile()
                }
            }
        }
    }
    
    
    
    
    /*func configureAlbums(newAlbums:[item]) -> [BrowseSectionType]{
        var sections:[BrowseSectionType] = []
        sections.append(.newReleases(viewModels: newAlbums.compactMap({
            return NewReleasesCellViewModel(name: $0.name, asrtworkURL: URL(string: $0.images.first?.url ?? ""), numberOfTracks: $0.total_tracks, artistName: $0.artists.first?.name ?? "-")
        })))
        return sections
    }
    
    func configurePlaylists(playlist:[itemOptions]) -> [BrowseSectionType]{
        var sections:[BrowseSectionType] = []
        sections.append(.featuredPlaylist(viewModels: playlist.compactMap({
            return FeaturedPlaylistCellViewModel(name: $0.name, artWorkURL: URL(string: $0.images.first?.url ?? ""), creatorName: $0.owner.display_name )
        })))
        return sections
    }
    
    func configureTracks(track:[AudioTrack]) -> [BrowseSectionType]{
        var sections:[BrowseSectionType] = []
        sections.append(.recommendedTracks(viewModels: track.compactMap({
            return RecommendedTrackCellViewModel(name: $0.name, artistName: $0.album.artists.first?.name ?? "-", artworkURL: URL(string: $0.album.images?.first?.url ?? ""))
        })))
        return sections
    }*/
    
    
    
    
    
    
    
    /*static func configureModels(newAlbums:[item],track:[AudioTrack],playlist:[itemOptions],collectionView:UICollectionView){
        self.newAlbums = newAlbums
        self.track = track
        self.playlist = playlist
        //Configure Models
        
        sections.append(.newReleases(viewModels: newAlbums.compactMap({
            return NewReleasesCellViewModel(name: $0.name, asrtworkURL: URL(string: $0.images.first?.url ?? ""), numberOfTracks: $0.total_tracks, artistName: $0.artists.first?.name ?? "-")
        })))
        sections.append(.featuredPlaylist(viewModels: playlist.compactMap({
            return FeaturedPlaylistCellViewModel(name: $0.name, artWorkURL: URL(string: $0.images.first?.url ?? ""), creatorName: $0.owner.display_name )
        })))
        sections.append(.recommendedTracks(viewModels: track.compactMap({
            return RecommendedTrackCellViewModel(name: $0.name, artistName: $0.album.artists.first?.name ?? "-", artworkURL: URL(string: $0.album.images.first?.url ?? ""))
        })))
        collectionView.reloadData()
        
    }*/
}
