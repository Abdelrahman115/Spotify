//
//  GenreCollectionViewCell.swift
//  Spotify
//
//  Created by Abdelrahman on 10/05/2023.
//

import UIKit
import SDWebImage
import BackgroundRemoval

class GenreCollectionViewCell: UICollectionViewCell {
    static let identifier = "GenreCollectionViewCell"
    
    private let imageView:UIImageView = {
       let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.tintColor = .white
        imageView.image = UIImage(systemName: "music.quarternote.3",withConfiguration: UIImage.SymbolConfiguration(pointSize: 50, weight: .regular))
        
        return imageView
        
    }()
    
    private let label:UILabel = {
       let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 22, weight: .semibold)
        label.numberOfLines = 0
        return label
    }()
    
    private var colors:[UIColor] = [.systemPurple,.systemGreen,.systemBlue,.systemRed,.systemYellow,.systemOrange,.systemPink]
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        //backgroundColor = .systemPurple
        contentView.layer.cornerRadius = 8
        contentView.layer.masksToBounds = true
        contentView.addSubview(imageView)
        contentView.addSubview(label)
        //imageView.layer.cornerRadius = 10
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        label.text = nil
        imageView.image = UIImage(systemName: "music.quarternote.3",withConfiguration: UIImage.SymbolConfiguration(pointSize: 50, weight: .regular))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        label.frame = CGRect(x: 10, y: contentView.height/2, width: contentView.width - 20, height: contentView.height/2)
        imageView.frame = CGRect(x: contentView.width/2+15, y: 10, width: contentView.height/2, height: contentView.height/2)
        imageView.layer.cornerRadius = contentView.height/4
        imageView.layer.masksToBounds = true
        
    }
    
    func configure(with viewModel:[categoriesItems],x:Int){
        label.text = viewModel[x].name
        imageView.sd_setImage(with: URL(string: viewModel[x].icons[0].url ?? ""))
        

        //imageView.image. = BackgroundRemoval.init()
        contentView.backgroundColor = colors.randomElement()
    }
}
