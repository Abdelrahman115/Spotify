//
//  SearchViewController.swift
//  Spotify
//
//  Created by Abdelrahman on 02/05/2023.
//

import UIKit

class SearchViewController: UIViewController {
    
    var viewModel:FetchCaregories!
    var resultModel:[categoriesItems] = []
    var id:String = ""
    var searchViewModel:FetchSearchResult!
    
    
    let searchController:UISearchController = {
       let searchController = UISearchController(searchResultsController: SearchResultsViewController())
        searchController.searchBar.placeholder = "Songs, Artists, Albums"
        searchController.searchBar.searchBarStyle = .minimal
        searchController.definesPresentationContext = true
        return searchController
    }()
    
    
    private let collectionView:UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewCompositionalLayout(sectionProvider: { _,_ -> NSCollectionLayoutSection in
            let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
            item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 7, bottom: 2, trailing: 7)
            //let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(150)),subitem: item,count: 2)
            
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .absolute(150)), repeatingSubitem: item, count: 2)
            group.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0)
            return NSCollectionLayoutSection(group: group)
        }))
        
        return collectionView
    }()

    
    // MARK: -Lifecycle
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
        view.backgroundColor = .systemBackground
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        navigationItem.searchController = searchController
    }
    
    private func fetchData(){
        viewModel = FetchCaregories()
        viewModel.fetchCategoriesData()
        viewModel.bindCategoriesDetails = {[weak self] in
            DispatchQueue.main.async {
                guard let self = self else {return}
                self.resultModel = (self.viewModel.categoryDetails?.categories.items)!
                self.collectionView.reloadData()
                
            }
        }
    }
    
    private func configureCollectionView(){
        view.addSubview(collectionView)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(GenreCollectionViewCell.self, forCellWithReuseIdentifier: GenreCollectionViewCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    

 

}


// MARK: - CollectionView Extensions

extension SearchViewController:UICollectionViewDelegate,UICollectionViewDataSource{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        resultModel.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GenreCollectionViewCell.identifier, for: indexPath) as! GenreCollectionViewCell
        let x = indexPath.row
        //cell.configure(with: resultModel!, x: x)
        cell.configure(with: resultModel, x: x)
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        HapticsManagr.shared.vibrateForSelection()
        
        
        //let album = newAlbums[indexPath.row]
        let vc = CategoryPlaylist()
        //vc.title = album.name
        vc.categoryName = resultModel[indexPath.row].name
        vc.categoryId = resultModel[indexPath.row].id
        vc.navigationItem.largeTitleDisplayMode = .always
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
}





// MARK: - Search result Extensions

extension SearchViewController:UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        
        
       
        //print(query)
        //Perform Search API Caller
    }
    
    
}

// MARK: - Search result Extensions

extension SearchViewController:UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let resultsController = searchController.searchResultsController as? SearchResultsViewController ,
        let query = searchBar.text,
        !query.trimmingCharacters(in: .whitespaces).isEmpty
        else{
            return
        }
        resultsController.delegate = self
        
        searchViewModel = FetchSearchResult()
        searchViewModel.fetchSearchResult(query: query)
        searchViewModel.bindSearchResult = {[weak self] in
            guard let self = self else {return}
            DispatchQueue.main.async {
                guard let searchResults = self.searchViewModel.searchResult else {return}
                resultsController.update(with:searchResults)
            }

        }
    }
}


// MARK: - Delegate Extensions

extension SearchViewController:SearchResultsViewControllerDelegate{
    func showResult(_ controller: UIViewController) {
        controller.navigationItem.largeTitleDisplayMode = .never
        controller.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(controller, animated: true)
    }
    
    
}
