//
//  HapticsManager.swift
//  Spotify
//
//  Created by Abdelrahman on 02/05/2023.
//

import Foundation
import UIKit


final class HapticsManagr{
    
    static let shared = HapticsManagr()
    private init(){}
    
    public func vibrateForSelection(){
        DispatchQueue.main.async {
            let generator = UISelectionFeedbackGenerator()
            generator.prepare()
            generator.selectionChanged()
        }
    }
    
    public func vibrate(for type:UINotificationFeedbackGenerator.FeedbackType){
        DispatchQueue.main.async {
            let generator = UINotificationFeedbackGenerator()
            generator.prepare()
            generator.notificationOccurred(type)
        }
    }
    
}
