//
//  LibraryPlaylistViewController.swift
//  Spotify
//
//  Created by Abdelrahman on 15/05/2023.
//

import UIKit

class LibraryPlaylistViewController: UIViewController {
    let userID = UserDefaults.standard.string(forKey: "userID") ?? ""
    public var selectionHandler:((itemOptions) -> Void)?
    
    private let noPlaylistView = ActionLabelView()

    private var viewModel:FetchCureentUserPlaylist!
    private var playlists:[itemOptions] = []
    
    private let tableView:UITableView = {
       let tableView = UITableView()
        tableView.register(SubtitleTableViewCell.self, forCellReuseIdentifier: SubtitleTableViewCell.identifier)
        tableView.isHidden = true
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
        noPlaylistView.frame = CGRect(x: 0, y: (view.height-150)/2, width: view.width, height: 150)
        noPlaylistView.center = view.center
    }
    
    private func setupUI(){
        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
        view.addSubview(noPlaylistView)
        noPlaylistView.configure(with: ActionLabelViewViewModel(text: "You don't have any playlist yet!", actionTitle: "Create"))
        noPlaylistView.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
        if selectionHandler != nil{
            navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(didTapClose))
        }
    }
    
    @objc private func didTapClose(){
        dismiss(animated: true)
    }
    
    private func updateUI(){
        if playlists.isEmpty{
            noPlaylistView.isHidden = false
            tableView.isHidden = true
        }else{
            //show table
            noPlaylistView.isHidden = true
            tableView.isHidden = false
        }
    }
    
    
    
   
    
    private func fetchData(){
        viewModel = FetchCureentUserPlaylist()
        viewModel.fetchCurrentUserPlaylist()
        viewModel.bindUserPlaylistResult = {
            DispatchQueue.main.async {
                guard let playlists = self.viewModel.currentUserPlaylists?.items else {return}
                self.playlists = playlists
                self.updateUI()
                self.tableView.reloadData()
            }
        }
    }

}


extension LibraryPlaylistViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        playlists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SubtitleTableViewCell.identifier, for: indexPath) as! SubtitleTableViewCell
        
        let viewModel = SubtitleTableViewCellViewModel(title: playlists[indexPath.row].name, url: playlists[indexPath.row].images.first?.url ?? "", artist: playlists[indexPath.row].owner.display_name)
        
        cell.configure(viewModel: viewModel)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        HapticsManagr.shared.vibrateForSelection()
        
        guard  selectionHandler == nil else{
            selectionHandler?(playlists[indexPath.row])
            dismiss(animated: true)
            return
        }
        
        let playlistModel = playlists[indexPath.row]
        let vc = PlaylistViewController(playlist: playlistModel)
        vc.title = playlists[indexPath.row].name
        vc.hidesBottomBarWhenPushed = true
        vc.navigationItem.largeTitleDisplayMode = .never
        
        if playlistModel.owner.id == userID{
            vc.isOwner = true
        }else{
            vc.isOwner = false
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let playlist = self.playlists[indexPath.row]
        let actionSheet = UIAlertController(title: "Remove", message: "Do you want to remove this track from your playlist?", preferredStyle: .alert)
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel,handler: nil))
        actionSheet.addAction(UIAlertAction(title: "Yes", style: .destructive,handler: { [weak self] _ in
            guard let self = self else{return}
            APICaller.shared.unfollowPlaylist(playlist: playlist) { [weak self] success in
                guard let self = self else{return}
                if success{
                    DispatchQueue.main.async {
                        self.playlists.remove(at: indexPath.row)
                        self.updateUI()
                        RealmManager.shared.deleteDatafromFavorites(id: playlist.id)
                        print("object Deleted")
                        self.tableView.reloadData()
                    }
                }
            }
        }))
        
        present(actionSheet,animated: true)
    }
}

extension LibraryPlaylistViewController:ActionLabelViewDelegate{
    public func showCreatePlaylistAlert(){
        let alert = UIAlertController(title: "New Playlist", message: "Enter Playlist Name", preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "Playlist..."
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Create", style: .default,handler: { _ in
            guard let field = alert.textFields?.first, let text = field.text ,!text.trimmingCharacters(in: .whitespaces).isEmpty else {return}
            
            APICaller.shared.createPlaylist(with: text) { [weak self] success in
                if success{
                    HapticsManagr.shared.vibrate(for: .success)
                    //Refresh list of playlists
                    self?.fetchData()
                    
                }else{
                    HapticsManagr.shared.vibrate(for: .error)
                    print("Failed to create playlist")
                }
            }
        }))
        present(alert,animated: true)
    }
    
    func didTapActionButton(_ actionView: ActionLabelView) {
        //Show Creation Ui for Playlist
        showCreatePlaylistAlert()
    }
}
