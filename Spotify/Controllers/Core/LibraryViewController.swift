//
//  LibraryViewController.swift
//  Spotify
//
//  Created by Abdelrahman on 02/05/2023.
//

import UIKit

class LibraryViewController: UIViewController {
    private var viewModel:FetchCureentUserPlaylist!
    private let playlistVC = LibraryPlaylistViewController()
    private let albumsVC = LibraryAlbumViewController()
    private let tracksVC = LibraryTrackViewController()
    private let toggleView = LibraryToggleView()
    
    private let scrollView:UIScrollView = {
      let scrollView = UIScrollView()
        scrollView.isPagingEnabled = true
        scrollView.isScrollEnabled = false
        return scrollView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        addChilderen()
        updateBarButtons()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.frame = CGRect(x: 0, y: view.safeAreaInsets.top + 55, width: view.width, height: view.height - view.safeAreaInsets.top - view.safeAreaInsets.bottom - 55)
        toggleView.frame = CGRect(x: 0, y: view.safeAreaInsets.top, width: 300, height: 55)
    }
    
    private func setupUI(){
        view.backgroundColor = .systemBackground
        scrollView.delegate = self
        scrollView.contentSize = CGSize(width: view.width*3, height: scrollView.height)
        view.addSubview(scrollView)
        view.addSubview(toggleView)
        toggleView.delegate = self
    }
    
    private func updateBarButtons(){
        switch toggleView.state{
        case.playlist:
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapAddButton))
        case.album:
            navigationItem.rightBarButtonItem = nil
        case.track:
            navigationItem.rightBarButtonItem = nil
        }
    }
    
    @objc private func didTapAddButton(){
        playlistVC.showCreatePlaylistAlert()
    }
    
    
    
    
    private func addChilderen(){
        addChild(playlistVC)
        scrollView.addSubview(playlistVC.view)
        playlistVC.view.frame = CGRect(x: 0, y: 0, width: scrollView.width, height: scrollView.height)
        playlistVC.didMove(toParent: self)
        
        addChild(albumsVC)
        scrollView.addSubview(albumsVC.view)
        albumsVC.view.frame = CGRect(x: view.width, y: 0, width: scrollView.width, height: scrollView.height)
        albumsVC.didMove(toParent: self)
        
        addChild(tracksVC)
        scrollView.addSubview(tracksVC.view)
        tracksVC.view.frame = CGRect(x: view.width*2, y: 0, width: scrollView.width, height: scrollView.height)
        tracksVC.didMove(toParent: self)
    }
}




extension LibraryViewController:UIScrollViewDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        /*if scrollView.contentOffset.x >= view.width-200{
            toggleView.updateForState(state: .track)
            updateBarButtons()
        }*/
        if scrollView.contentOffset.x >= view.width {
            toggleView.updateForState(state: .album)
            updateBarButtons()
            
        }
        if scrollView.contentOffset.x >= view.width*2{
            toggleView.updateForState(state: .track)
            updateBarButtons()
        }
        if scrollView.contentOffset.x < view.width{
            toggleView.updateForState(state: .playlist)
            updateBarButtons()
        }
        
        /*else{
            toggleView.updateForState(state: .playlist)
            updateBarButtons()
        }*/
    }
}


extension LibraryViewController:LibraryToggleViewDelegate{
    func didTapTracksButton(_ toggleView: LibraryToggleView) {
        scrollView.setContentOffset(CGPoint(x: view.width*2, y: 0), animated: true)
    }
    
    func didTapAlbumsButton(_ toggleView: LibraryToggleView) {
        scrollView.setContentOffset(CGPoint(x: view.width, y: 0), animated: true)
    }
    
    func didTapPlaylistButton(_ toggleView: LibraryToggleView) {
        scrollView.setContentOffset(.zero, animated: true)
    }
    
    
}
