//
//  HeaderView.swift
//  Spotify
//
//  Created by Abdelrahman on 06/05/2023.
//

import UIKit

class HeaderView: UICollectionReusableView {
    static let identifier = "HeaderView"
    
    let headerLbl:UILabel = {
      let label = UILabel()
        label.textColor = .label
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 24, weight: .bold)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(headerLbl)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        headerLbl.frame = CGRect(x: 5, y: 0, width: self.width, height: 50)
    }
}
