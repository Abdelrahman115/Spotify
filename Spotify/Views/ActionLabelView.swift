//
//  ActionLabelView.swift
//  Spotify
//
//  Created by Abdelrahman on 15/05/2023.
//

import UIKit

struct ActionLabelViewViewModel{
    let text:String
    let actionTitle:String
}

protocol ActionLabelViewDelegate:AnyObject{
    func didTapActionButton(_ actionView:ActionLabelView)
}

class ActionLabelView: UIView {
    
    weak var delegate:ActionLabelViewDelegate?
    
    private let label:UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = .secondaryLabel
        return label
    }()
    
    private let button:UIButton = {
        let button = UIButton()
        button.setTitleColor(.white,for: .normal)
        button.backgroundColor = .systemGreen
        
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        isHidden = true
        clipsToBounds = true
        addSubview(label)
        addSubview(button)
        button.addTarget(self, action: #selector(didTapActionButton), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        button.frame = CGRect(x: width/4, y: height-40, width: width/2, height: 40)
        label.frame = CGRect(x: 0, y: 0, width: width, height: height-45)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 20
        
    }
    
    @objc private func didTapActionButton(){
        delegate?.didTapActionButton(self)
    }
    
    func configure(with viewModel: ActionLabelViewViewModel){
        label.text = viewModel.text
        button.setTitle(viewModel.actionTitle, for: .normal)
    }
    
    
}
