//
//  APICaller.swift
//  Spotify
//
//  Created by Abdelrahman on 02/05/2023.
//

import Foundation

final class APICaller{
    static let shared = APICaller()
    
    private init(){}
    
    struct Constants{
        static let baseURL = "https://api.spotify.com/v1"
    }
    
    enum APIError:Error{
        case failedToGetData
    }
    
    // MARK: - Current User Profile
    public func getCurrentUserProfile(completion:@escaping(Result<UserProfile,Error>)->Void){
        createRequest(with: URL(string: Constants.baseURL + "/me"), type: .GET) { baseRquest in
            let task = URLSession.shared.dataTask(with: baseRquest) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                
                do{
                    
                    let result = try JSONDecoder().decode(UserProfile.self, from: data)
                    
                    completion(.success(result))
                }catch{
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    
    // MARK: - Browse APIs
    public func getNewReleases(completion:@escaping (Result<NewReleasesResponse,Error>) -> Void){
        createRequest(with: URL(string: Constants.baseURL + "/browse/new-releases?limit=50"), type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data , error == nil else{
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                
                do{
                    //let json = try JSONSerialization.jsonObject(with: data,options: .allowFragments)
                   //print(json)
                    let result = try JSONDecoder().decode(NewReleasesResponse.self, from: data)
                    //print(result.albums.href)
                    completion(.success(result))
                }catch{
                    debugPrint(error)
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    
    public func getFeaturedPlaylists(completion:@escaping(Result<FeaturedPlaylist,Error>) ->Void){
        createRequest(with: URL(string: Constants.baseURL + "/browse/featured-playlists?limit=9") , type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data , error == nil else{
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                do{
                    //let json = try JSONSerialization.jsonObject(with: data,options: .allowFragments)
                   //print(json)
                    let result = try JSONDecoder().decode(FeaturedPlaylist.self, from: data)
                    //print(result.playlists.total)
                    completion(.success(result))
                }catch{
                    debugPrint(error)
                    completion(.failure(error))
                }
                
            }
            task.resume()
        }
    }
    
    public func getRecommendationsGenres(completion:@escaping(Result<RecommendedGenre,Error>)->Void){
        createRequest(with: URL(string: Constants.baseURL + "/recommendations/available-genre-seeds"), type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                do{
                    let result = try JSONDecoder().decode(RecommendedGenre.self, from: data)
                    completion(.success(result))
                }catch{
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    
    public func getRecommendations(genres:Set<String>,completion:@escaping(Result<RecommendationsResponse,Error>)->Void){
        let seeds = genres.joined(separator: ",")
        //print(seeds)
        createRequest(with: URL(string: Constants.baseURL + "/recommendations?limit=40&seed_genres=\(seeds)"), type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                do{
                    let result = try JSONDecoder().decode(RecommendationsResponse.self, from: data)
                    completion(.success(result))
                }catch{
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    // MARK: - Albums
    
    public func getAlbumDetails(for album:item,completion: @escaping(Result<AlbumDetailsResponse,Error>)->Void){
        createRequest(with: URL(string: Constants.baseURL + "/albums/" + album.id), type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {completion(.failure(APIError.failedToGetData)); return}
                
                do{
                    //let json = try JSONSerialization.jsonObject(with: data,options: .allowFragments)
                    //print(json)
                    let result = try JSONDecoder().decode(AlbumDetailsResponse.self, from: data)
                    completion(.success(result))
                    //print(result)
                }catch{
                    print(error.localizedDescription)
                    completion(.failure(error))
                }
                
            }
            task.resume()
        }
    }
    
    // MARK: - Playlists
    
    public func getPlaylistDetails(for playlist:itemOptions,completion: @escaping(Result<PlaylistDetailsResponse,Error>)->Void){
        createRequest(with: URL(string: Constants.baseURL + "/playlists/" + playlist.id), type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {completion(.failure(APIError.failedToGetData)); return}
                
                do{
                    //let json = try JSONSerialization.jsonObject(with: data,options: .allowFragments)
                    //print(json)
                    let result = try JSONDecoder().decode(PlaylistDetailsResponse.self, from: data)
                    completion(.success(result))
                    //print(result.images[0].url)
                }catch{
                    debugPrint(error)
                    print(error.localizedDescription)
                    completion(.failure(error))
                }
                
            }
            task.resume()
        }
    }
    
    
    
    // MARK: - Categories
    
    public func getCategories(completion: @escaping(Result<Categories,Error>) -> Void){
        createRequest(with: URL(string: Constants.baseURL + "/browse/categories?limit=50"), type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {return}
                
                do{
                    let result = try JSONDecoder().decode(Categories.self, from: data)
                    //print(result.categories.href)
                    completion(.success(result))
                }catch{
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    
    
    // MARK: - Categories Playlists
    public func getCategoriesPlaylists(category:String,completion: @escaping(Result<CategoryPlaylistResponse,Error>) -> Void){
        createRequest(with: URL(string: Constants.baseURL + "/browse/categories/\(category)/playlists"), type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {return}
                
                do{
                    //let json = try JSONSerialization.jsonObject(with: data,options: .allowFragments)
                    //print(json)
                    let result = try JSONDecoder().decode(CategoryPlaylistResponse.self, from: data)
                    
                    completion(.success(result))
                }catch{
                    print(error.localizedDescription)
                    debugPrint(error)
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    
    
    // MARK: - Search
    
    public func search(with query:String,completion:@escaping(Result<SearchResultResponse,Error>) -> Void){
        createRequest(with: URL(string: Constants.baseURL + "/search?limit=10&type=album,artist,playlist,track&q=\(query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")"), type: .GET) { request in
            print(request.url?.absoluteString ?? "none")
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data , error == nil else {return}
                
                do{
                    /*let json = try JSONSerialization.jsonObject(with: data)
                    print(json)*/
                    let result = try JSONDecoder().decode(SearchResultResponse.self, from: data)
                    completion(.success(result))
                }catch{
                    print(error.localizedDescription)
                    debugPrint(error)
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    
    // MARK: - Library
    
    public func getCurrentUserPlaylist(completion:@escaping (Result<playlist,Error>) -> Void){
        createRequest(with: URL(string: Constants.baseURL + "/me/playlists/?limit=50") , type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data , error == nil else {return}
                
                do{
                    //let json = try JSONSerialization.jsonObject(with: data,options: .allowFragments)
                    //print(json)
                    let result = try JSONDecoder().decode(playlist.self, from: data)
                    completion(.success(result))
                    //print(result.items[1].name)
                }catch{
                    completion(.failure(error))
                    print(error.localizedDescription)
                }
            }
            task.resume()
        }
    }
    
    public func createPlaylist(with name:String,completion:@escaping (Bool) -> Void){
        getCurrentUserProfile { [weak self] result in
            switch result{
            case.success(let profile):
                let urlString = Constants.baseURL + "/users/\(profile.id)/playlists"
                self?.createRequest(with: URL(string: urlString), type: .POST) { baseRequest in
                    var request = baseRequest
                    let json = ["name":name]
                    request.httpBody = try? JSONSerialization.data(withJSONObject: json)
                    
                    let task = URLSession.shared.dataTask(with: request) { data, _, error in
                        guard let data = data , error == nil else{return}
                        do{
                            let json = try JSONSerialization.jsonObject(with: data,options: .allowFragments)
                            print(json)
                            _ = try JSONDecoder().decode(itemOptions.self, from: data)
                            completion(true)
                        }catch{
                            completion(false)
                            print(error.localizedDescription)
                        }
                    }
                    task.resume()
                }
            case.failure(let error):
                print(error.localizedDescription)
                break
                
            }
        }
    }
    
    public func addTrackToPlaylist(track:AudioTrack, playlist:itemOptions,completion:@escaping(Bool)->Void){
        
        createRequest(with: URL(string: Constants.baseURL + "/playlists/\(playlist.id)/tracks"), type: .POST) { baseRequest in
            var request = baseRequest
            let json = ["uris":["spotify:track:\(track.id)"]]
            request.httpBody = try? JSONSerialization.data(withJSONObject: json)
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data , error == nil else{return}
                do{
                    let result = try JSONSerialization.jsonObject(with: data,options: .allowFragments)
                    //print(result)
                    if let response = result as? [String:Any],response["snapshot_id"] as? String != nil{
                        completion(true)
                    }else{
                        completion(false)
                    }
                    //print(json)
                }catch{
                    print(error.localizedDescription)
                    completion(false)
                }
            }
            
            task.resume()
        }
    }
    
    public func removeTrackFromPlaylist(track:AudioTrack,playlist:itemOptions,completion:@escaping(Bool)->Void){
        createRequest(with: URL(string: Constants.baseURL + "/playlists/\(playlist.id)/tracks"), type: .DELETE) { baseRequest in
            var request = baseRequest
            let json = ["tracks":[["uri":"spotify:track:\(track.id)"]]]
            request.httpBody = try? JSONSerialization.data(withJSONObject: json)
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data , error == nil else{return}
                do{
                    let result = try JSONSerialization.jsonObject(with: data,options: .allowFragments)
                    //print(result)
                    if let response = result as? [String:Any],response["snapshot_id"] as? String != nil{
                        completion(true)
                    }else{
                        completion(false)
                    }
                    //print(json)
                }catch{
                    print(error.localizedDescription)
                    completion(false)
                }
            }
            
            task.resume()
        }
    }
    
    
    public func likePlaylist(playlist:itemOptions,completion:@escaping(Bool) -> Void){
        createRequest(with: URL(string: Constants.baseURL + "/playlists/\(playlist.id)/followers"), type: .PUT) { baseRequest in
            let request = baseRequest
            //let json = ["uris":["spotify:track:\(track.id)"]]
            //request.httpBody = try? JSONSerialization.data(withJSONObject: json)
            //request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            let task =  URLSession.shared.dataTask(with: request) { data, _, error in
                //guard let data = data, error == nil else{return}
                do{
                    completion(true)
                }/*catch{
                    print(error.localizedDescription)
                    debugPrint(error)
                    completion(false)
                }*/
            }
            task.resume()
        }
    }
    
    public func unfollowPlaylist(playlist:itemOptions,completion:@escaping(Bool) -> Void){
        createRequest(with: URL(string: Constants.baseURL + "/playlists/\(playlist.id)/followers"), type: .DELETE) { baseRequest in
            let request = baseRequest
            //let json = ["uris":["spotify:track:\(track.id)"]]
            //request.httpBody = try? JSONSerialization.data(withJSONObject: json)
            //request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            let task =  URLSession.shared.dataTask(with: request) { data, _, error in
                //guard let data = data, error == nil else{return}
                do{
                    completion(true)
                }/*catch{
                    print(error.localizedDescription)
                    debugPrint(error)
                    completion(false)
                }*/
            }
            task.resume()
        }
    }
    
    
    public func getCurrentUserAlbums(completion:@escaping (Result<CurrentUserAlbumsResponse,Error>) -> Void){
        createRequest(with: URL(string: Constants.baseURL + "/me/albums/?limit=50") , type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data , error == nil else {return}
                
                do{
                    /*let json = try JSONSerialization.jsonObject(with: data,options: .allowFragments)
                    print(json)*/
                    let result = try JSONDecoder().decode(CurrentUserAlbumsResponse.self, from: data)
                    completion(.success(result))
                    //*print(result.items.first?.album.name)
                }catch{
                    completion(.failure(error))
                    print(error.localizedDescription)
                    debugPrint(error)
                }
            }
            task.resume()
        }
    }
    
    
    public func likeAlbum(album:item,completion:@escaping(Bool) -> Void){
        createRequest(with: URL(string: Constants.baseURL + "/me/albums?ids=\(album.id)"), type: .PUT) { baseRequest in
            let request = baseRequest
            //let json = ["uris":["spotify:track:\(track.id)"]]
            //request.httpBody = try? JSONSerialization.data(withJSONObject: json)
            //request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            let task =  URLSession.shared.dataTask(with: request) { data, _, error in
                //guard let data = data, error == nil else{return}
                do{
                    completion(true)
                }/*catch{
                    print(error.localizedDescription)
                    debugPrint(error)
                    completion(false)
                }*/
            }
            task.resume()
        }
    }
    
    public func unfollowAlbum(album:item,completion:@escaping(Bool) -> Void){
        createRequest(with: URL(string: Constants.baseURL + "/me/albums?ids=\(album.id)"), type: .DELETE) { baseRequest in
            let request = baseRequest
            //let json = ["uris":["spotify:track:\(track.id)"]]
            //request.httpBody = try? JSONSerialization.data(withJSONObject: json)
            //request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            let task =  URLSession.shared.dataTask(with: request) { data, _, error in
                //guard let data = data, error == nil else{return}
                do{
                    completion(true)
                }/*catch{
                    print(error.localizedDescription)
                    debugPrint(error)
                    completion(false)
                }*/
            }
            task.resume()
        }
    }
    
    
    public func getCurrentUserTracks(completion:@escaping (Result<CureentUserTracksResponse,Error>) -> Void){
        createRequest(with: URL(string: Constants.baseURL + "/me/tracks/?limit=50") , type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data , error == nil else {return}
                
                do{
                    //let json = try JSONSerialization.jsonObject(with: data,options: .allowFragments)
                    //print(json)
                    let result = try JSONDecoder().decode(CureentUserTracksResponse.self, from: data)
                    completion(.success(result))
                    //print(result.href)
                }catch{
                    completion(.failure(error))
                    print(error.localizedDescription)
                    debugPrint(error)
                }
            }
            task.resume()
        }
    }
    
    
    
    public func likeTrack(id:String,completion:@escaping(Bool) -> Void){
        createRequest(with: URL(string: Constants.baseURL + "/me/tracks?ids=\(id)"), type: .PUT) { baseRequest in
            var request = baseRequest
            //let json = ["uris":["spotify:track:\(track.id)"]]
            //request.httpBody = try? JSONSerialization.data(withJSONObject: json)
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            let task =  URLSession.shared.dataTask(with: request) { data, _, error in
                //guard let data = data, error == nil else{return}
                do{
                    completion(true)
                }/*catch{
                    print(error.localizedDescription)
                    debugPrint(error)
                    completion(false)
                }*/
            }
            task.resume()
        }
    }
    
    public func unlikeTrack(id:String,completion:@escaping(Bool) -> Void){
        createRequest(with: URL(string: Constants.baseURL + "/me/tracks?ids=\(id)"), type: .DELETE) { baseRequest in
            var request = baseRequest
            //let json = ["uris":["spotify:track:\(track.id)"]]
            //request.httpBody = try? JSONSerialization.data(withJSONObject: json)
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            let task =  URLSession.shared.dataTask(with: request) { data, _, error in
                //guard let data = data, error == nil else{return}
                do{
                    completion(true)
                }/*catch{
                    print(error.localizedDescription)
                    debugPrint(error)
                    completion(false)
                }*/
            }
            task.resume()
        }
    }
    
    
    
    
    
    // MARK: - private genaric api request
    
    enum HTTPMethod:String{
        case GET
        case POST
        case PUT
        case DELETE
    }
    
    private func createRequest(with url:URL?,type:HTTPMethod,completion:@escaping(URLRequest)->Void){
        guard let apiURL = url else{return}
        //guard self != nil else {return}
        AuthManager.shared.withValidToken { token in
            var request = URLRequest(url: apiURL)
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            request.httpMethod = type.rawValue
            request.timeoutInterval = 30
            completion(request)
        }
    }
}
