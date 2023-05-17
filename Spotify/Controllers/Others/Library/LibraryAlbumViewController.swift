//
//  LibraryAlbumViewController.swift
//  Spotify
//
//  Created by Abdelrahman on 15/05/2023.
//

import UIKit

class LibraryAlbumViewController: UIViewController {
    let userID = UserDefaults.standard.string(forKey: "userID") ?? ""
    
    private let noAlbumsView = ActionLabelView()

    private var viewModel:FetchCureentUserAlbums!
    private var albums:[item] = []
    
    private let tableView:UITableView = {
       let tableView = UITableView()
        tableView.register(SubtitleTableViewCell.self, forCellReuseIdentifier: SubtitleTableViewCell.identifier)
        tableView.isHidden = true
        //tableView.backgroundColor = .yellow
        return tableView
    }()
    
    private let noAlbumsLabel:UILabel = {
       let label = UILabel()
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.text = "There are no albums in your library"
        label.backgroundColor = .red
        label.isHidden = false
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        //updateUI()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        albums.removeAll()
        fetchData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
       tableView.frame = view.bounds
        noAlbumsView.frame = CGRect(x: 0, y: (view.height-150)/2, width: view.width, height: 150)
        
        //noAlbumsView.center = self.view.center
        
    }
    
    private func setupUI(){
        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
        view.addSubview(noAlbumsView)
        noAlbumsView.configure(with: ActionLabelViewViewModel(text: "You didn't save any albums yet", actionTitle: "Browse"))
        noAlbumsView.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false

    }
    
    @objc private func didTapClose(){
        dismiss(animated: true)
    }
    
    private func updateUI(){
        if albums.isEmpty{
            noAlbumsView.isHidden = false
            tableView.isHidden = true
        }else{
            //show table
            noAlbumsView.isHidden = true
            tableView.isHidden = false
        }
    }
    
    private func fetchData(){
        viewModel = FetchCureentUserAlbums()
        viewModel.fetchCurrentUserAlbums()
        viewModel.bindUserAlbumstResult = {
            DispatchQueue.main.async {
                guard let albums = self.viewModel.currentUserAlbums?.items else {return}
                
                for each in albums{
                    self.albums.append(each.album)
                    //self.albums.append(each.album)
                }
                //print(self.albums.count)
                self.updateUI()
                self.tableView.reloadData()
            }
        }
    }

}


extension LibraryAlbumViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        albums.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SubtitleTableViewCell.identifier, for: indexPath) as! SubtitleTableViewCell
        
        let viewModel = SubtitleTableViewCellViewModel(title: albums[indexPath.row].name, url: albums[indexPath.row].images.first?.url ?? "", artist: albums[indexPath.row].artists.first?.name ?? "")
        
        cell.configure(viewModel: viewModel)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        HapticsManagr.shared.vibrateForSelection()
        
        let album = albums[indexPath.row]
        let vc = AlbumViewController(album: album)
        vc.title = album.name
        vc.hidesBottomBarWhenPushed = true
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let album = self.albums[indexPath.row]
        let actionSheet = UIAlertController(title: "Remove", message: "Do you want to remove this Album from your Favorites?", preferredStyle: .alert)
        actionSheet.addAction(UIAlertAction(title: "Yes", style: .destructive,handler: { [weak self] _ in
            guard let self = self else{return}
            APICaller.shared.unfollowAlbum(album: album) { [weak self] success in
                guard let self = self else{return}
                if success{
                    DispatchQueue.main.async {
                        self.albums.remove(at: indexPath.row)
                        self.updateUI()
                        RealmManager.shared.deleteDatafromFavorites(id: album.id)
                        self.tableView.reloadData()
                    }
                }
            }
        }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel,handler: nil))
        present(actionSheet,animated: true)
    }
}

extension LibraryAlbumViewController:ActionLabelViewDelegate{
    func didTapActionButton(_ actionView: ActionLabelView) {
        
        tabBarController?.selectedIndex = 0
    }
    
}

