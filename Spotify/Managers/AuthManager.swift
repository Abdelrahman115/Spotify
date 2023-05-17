//
//  AuthManager.swift
//  Spotify
//
//  Created by Abdelrahman on 02/05/2023.
//

import Foundation

final class AuthManager{
    static let shared = AuthManager()
    private var refreshenToken:Bool = false
    struct Constants{
        static let clientID = "64526f85532447a89febc23fcf3a0e2c"
        static let clientSecret = "f6e08d8b32e747f7be6f75b733682635"
        static let tokenApiUrl = "https://accounts.spotify.com/api/token"
        static let redirectURI = "https://www.iosacademy.io"
        static let scopes = "user-read-private%20playlist-modify-public%20playlist-read-private%20playlist-modify-private%20user-follow-read%20user-library-modify%20user-library-read%20user-read-email"
    }
    
    private init(){}
    
    public var signInURL:URL?{
        let base = "https://accounts.spotify.com/authorize"
        //let scopes = "user-read-private"
        //let redirectURI = "https://www.iosacademy.io"
        let string = "\(base)?response_type=code&client_id=\(Constants.clientID)&scope=\(Constants.scopes)&redirect_uri=\(Constants.redirectURI)&show_dialog=TRUE"
        
        return URL(string: string)
        
    }
    
    var isSignedIn:Bool{
        return accessToken != nil
        //return false
    }
    
    private var accessToken:String?{
        return UserDefaults.standard.string(forKey: "access_token")
    }
    
    private var refreshToken:String?{
        return UserDefaults.standard.string(forKey: "refresh_token")
    }
    
    private var tokenExpirationDate:Date?{
        return UserDefaults.standard.object(forKey: "expirationDate") as? Date
    }
    
    private var shouldRefreshToken:Bool{
        guard let expirationDate = tokenExpirationDate else {return false}
        let currentDate = Date()
        let fiveMinutes:TimeInterval = 300
        return currentDate.addingTimeInterval(fiveMinutes) >= expirationDate
    }
    
    public func exchangeCodeForToken(code:String,completion:@escaping (Bool) -> Void){
        //Get Token
        guard let url = URL(string: Constants.tokenApiUrl) else {return}
        var components = URLComponents()
        components.queryItems = [URLQueryItem(name: "grant_type", value: "authorization_code"),
                                URLQueryItem(name: "code", value: code),
                                 URLQueryItem(name: "redirect_uri", value: Constants.redirectURI),]
        
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpBody = components.query?.data(using: .utf8)
        
        let basicToken = Constants.clientID+":"+Constants.clientSecret
        let data = basicToken.data(using: .utf8)
        guard let base64String = data?.base64EncodedString() else {print("Failue");completion(false);return}
        
        request.setValue("Basic \(base64String)", forHTTPHeaderField: "Authorization")
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, _, error in
            guard let self = self else {return}
            guard let data = data,error == nil else { completion(false); return}
            //print(data)
            //print(error)
            do{
                let result = try JSONDecoder().decode(AuthResponse.self, from: data)
                self.casheToken(result:result)
                completion(true)
            }catch{
                print(error.localizedDescription)
                completion(false)
            }
            
        }
        
        task.resume()
        
    }
    
    private var onRefreshBlocks = [((String)->Void)]()
    
    /// Supplies valid token to be used with API Calls
    public func withValidToken(completion:@escaping(String)->Void){
        guard !refreshenToken else {
            onRefreshBlocks.append(completion)
            return
        }
        if shouldRefreshToken{
            //Refresh
            refreshIfNeeded { [weak self] success in
                guard let self = self else{return}
                if success{
                    if let token = self.accessToken{
                        completion(token)
                    }
                }
            }
        }else if let token = accessToken{
            completion(token)
        }
    }
    
    public func refreshIfNeeded(completion:((Bool)->Void)?){
        guard !refreshenToken else {return}
        guard shouldRefreshToken else {completion?(true);return }
        guard let refreshToken = self.refreshToken else {return}
        guard let url = URL(string: Constants.tokenApiUrl) else {return}
        refreshenToken = true
        var components = URLComponents()
        components.queryItems = [URLQueryItem(name: "grant_type", value: "refresh_token"),
                                URLQueryItem(name: "refresh_token", value: refreshToken),]
        
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpBody = components.query?.data(using: .utf8)
        
        let basicToken = Constants.clientID+":"+Constants.clientSecret
        let data = basicToken.data(using: .utf8)
        guard let base64String = data?.base64EncodedString() else {print("Failue");completion?(false);return}
        
        request.setValue("Basic \(base64String)", forHTTPHeaderField: "Authorization")
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, _, error in
            self?.refreshenToken = false
            guard let self = self else {return}
            guard let data = data,error == nil else { completion?(false); return}
            //print(data)
            //print(error)
            do{
                let result = try JSONDecoder().decode(AuthResponse.self, from: data)
                self.onRefreshBlocks.forEach {$0(result.access_token)}
                self.onRefreshBlocks.removeAll()
                self.casheToken(result:result)
                completion?(true)
            }catch{
                print(error.localizedDescription)
                completion?(false)
            }
            
        }
        
        task.resume()
        
    }
    
    public func casheToken(result:AuthResponse){
        UserDefaults.standard.set(result.access_token, forKey: "access_token")
        if let refresh_token = result.refresh_token{
            UserDefaults.standard.set(refresh_token, forKey: "refresh_token")
        }
        UserDefaults.standard.set(Date().addingTimeInterval(TimeInterval(result.expires_in)), forKey: "expirationDate")
    }
    
    
    public func signOUT(completion:(Bool) -> Void){
        UserDefaults.standard.set(nil, forKey: "access_token")
        UserDefaults.standard.set(nil, forKey: "refresh_token")
        UserDefaults.standard.set(nil, forKey: "expirationDate")
        completion(true)
    }
    
}
