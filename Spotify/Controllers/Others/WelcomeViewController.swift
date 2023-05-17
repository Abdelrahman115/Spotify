//
//  WelcomeViewController.swift
//  Spotify
//
//  Created by Abdelrahman on 02/05/2023.
//

import UIKit

class WelcomeViewController: UIViewController {
    
    
    private let imageView:UIImageView = {
       let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "welcome")
        return imageView
    }()
    
    private let signInButton:UIButton = {
       let button = UIButton()
        button.backgroundColor = .white
        button.setTitle("Sign In With Spotify", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = 25
        
        return button
    }()
    
    private let overlayView:UIView = {
       let overlayView = UIView()
        overlayView.backgroundColor = .black
        overlayView.alpha = 0.7
        return overlayView
    }()
    
    private let logoImageView:UIImageView = {
       let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "logo2")
        return imageView
    }()
    
    private let label:UILabel = {
       let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .white
        label.font = .systemFont(ofSize: 32, weight: .semibold)
        label.text = "Listen to Million of songs"
        label.textAlignment = .center
        return label
    }()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        signInButton.frame = CGRect(x: 20, y: view.height-200-view.safeAreaInsets.bottom, width: view.width-40, height: 50)
        imageView.frame = view.bounds
        overlayView.frame = view.bounds
        logoImageView.frame = CGRect(x: (view.width-120)/2, y: (view.height-350)/2, width: 120, height: 120)
        label.frame = CGRect(x: 30, y: logoImageView.bottom + 30, width: view.width-60, height: 150)
        
        
    }
    
    
    
    private func setupUI(){
        //title = "Spotify"
        view.addSubview(imageView)
        view.addSubview(overlayView)
        view.backgroundColor = .black
        view.addSubview(signInButton)
        view.addSubview(logoImageView)
        view.addSubview(label)
        signInButton.addTarget(self, action: #selector(didTabSignIn), for: .touchUpInside)
    }
    
    @objc private func didTabSignIn(){
        let vc = AuthViewController()
        vc.navigationItem.largeTitleDisplayMode = .never
        vc.completionHandler = {[weak self] success in
            guard let self = self else {return}
            DispatchQueue.main.async {
                self.handleSignIn(success:success)
            }
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func handleSignIn(success:Bool){
        guard success else {
            let alert = UIAlertController(title: "Oops", message: "Something went wrong when signing in", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel))
            present(alert,animated: true)
            return}
        let mainAppTabBarVC = TabBarViewController()
        mainAppTabBarVC.modalPresentationStyle = .fullScreen
        present(mainAppTabBarVC,animated: true)
    }
    

   

}
