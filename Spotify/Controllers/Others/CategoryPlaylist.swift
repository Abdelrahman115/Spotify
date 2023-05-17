//
//  CategoryPlaylist.swift
//  Spotify
//
//  Created by Abdelrahman on 12/05/2023.
//

import UIKit

class CategoryPlaylist: UIViewController {
    var viewModel:FetchCaregoriePlaylist!
    
    var categoryName:String = ""
    var categoryId:String = ""
    
    private var playlist:[itemOptions] = []
    
    private var viewModels = [FeaturedPlaylistCellViewModel]()

    private var collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewCompositionalLayout(sectionProvider: { _, _ -> NSCollectionLayoutSection? in
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
        item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 7, bottom: 2, trailing: 7)
        //let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(220)),subitem: item,count: 2)
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .absolute(220)), repeatingSubitem: item, count: 2)
        
        return NSCollectionLayoutSection(group: group)
    }))
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configureCollectionView()
        fetchData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }
    
    private func setupUI(){
        title = categoryName
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func fetchData(){
        viewModel = FetchCaregoriePlaylist()
        viewModel.fetchCategoriesData(id: categoryId)
        viewModel.bindCategoriyPlaylistDetails = {[weak self] in
            guard let self = self else {return}
            DispatchQueue.main.async {
                self.viewModels = (self.viewModel.categoryDetails?.playlists.items.compactMap({
                    FeaturedPlaylistCellViewModel(name:$0.name , artWorkURL: URL(string: $0.images.first?.url ?? ""), creatorName: $0.owner.display_name)
                }))!
                self.playlist = (self.viewModel.categoryDetails?.playlists.items)!
                self.collectionView.reloadData()
            }
        }
    }
    
    private func configureCollectionView(){
        collectionView.register(FeaturedPlaylistCollectionViewCell.self, forCellWithReuseIdentifier: FeaturedPlaylistCollectionViewCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        view.addSubview(collectionView)
    }
    

  

}


// MARK: - Collection View Extensions
extension CategoryPlaylist:UICollectionViewDelegate,UICollectionViewDataSource{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModels.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeaturedPlaylistCollectionViewCell.identifier, for: indexPath) as! FeaturedPlaylistCollectionViewCell
        
        cell.configure1(viewModels:viewModels,Index: indexPath.row)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let playlist = playlist[indexPath.row]
        let vc = PlaylistViewController(playlist: playlist)
        vc.title = playlist.name
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
}
