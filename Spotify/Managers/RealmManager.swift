//
//  RealmManager.swift
//  Spotify
//
//  Created by Abdelrahman on 17/05/2023.
//

import Foundation
import RealmSwift


import RealmSwift

class RealmManager {
    static let shared = RealmManager()
    
    private let realm: Realm
    private init() {
        do {
            self.realm = try Realm()
        } catch {
            fatalError("Failed to initialize Realm: \(error.localizedDescription)")
        }
    }
    
    func saveDataToFavorites(obj:Favorites){
        try! Realm().beginWrite()
        try! Realm().add(obj)
        try! Realm().commitWrite()
    }
    
    func deleteDatafromFavorites(id:String){
        let delProduct = try! Realm().objects(Favorites.self).filter("id == %@",id)
         try! Realm().write({
             try! Realm().delete(delProduct)
         })
    }
    
    func getAllObjects<T: Object>(_ type: T.Type) -> Results<T> {
        return realm.objects(type)
    }
    
    
    func deleteAll() {
        let realm = try! Realm()
        try! realm.write {
            realm.deleteAll()
        }
    }
    
}
