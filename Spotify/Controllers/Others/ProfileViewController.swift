//
//  ProfileViewController.swift
//  Spotify
//
//  Created by Abdelrahman on 02/05/2023.
//

import UIKit
import SDWebImage

class ProfileViewController: UIViewController {
    
    private let tableView:UITableView = {
       let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        return tableView
    }()
    private var model:UserProfile?
    private var models:[String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        fetchProfile()
        tableView.reloadData()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    
    
    private func setupUI(){
        title = "Profile"
        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
        tableView.isHidden = true
        //tableView.backgroundColor = .systemBackground
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    
    
    private func fetchProfile(){
        APICaller.shared.getCurrentUserProfile { [weak self] result in
            switch result{
            case.success(let model):
                DispatchQueue.main.async {
                    self?.updateUI(with: model)
                }
            case.failure(let error):
                DispatchQueue.main.async {
                    print(error.localizedDescription)
                    self?.failedToGetProfile()
                }
            }

        }
    }
    
    
    private func updateUI(with model:UserProfile){
        tableView.isHidden = false
        self.model = model
        self.models.append("Full Name: \(model.display_name)")
        self.models.append("Email: \(model.email)")
        self.models.append("User ID: \(model.id)")
        self.models.append("Plan: \(model.product)")
        guard let url = model.images?[0].url else {return}
        createTableHeader(with: url)
        tableView.reloadData()
    }
    
    private func failedToGetProfile(){
        let label = UILabel(frame: .zero)
        label.text = "Failed to load Profile"
        label.sizeToFit()
        label.textColor = .secondaryLabel
        view.addSubview(label)
        label.center = view.center
    }
    
    private func createTableHeader(with url:String?){
        guard let urlString = url , let url = URL(string: urlString) else {return}
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: view.width, height: view.width/1.5))
        let imageSize:CGFloat = headerView.height/2
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: imageSize, height: imageSize))
        headerView.addSubview(imageView)
        imageView.contentMode = .scaleAspectFit
        imageView.center = headerView.center
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = imageSize/2
        imageView.sd_setImage(with: url)
        tableView.tableHeaderView = headerView
    }
}

// MARK: - TableView
extension ProfileViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        models.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = models[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return "Profile"
    }
    
    
}

