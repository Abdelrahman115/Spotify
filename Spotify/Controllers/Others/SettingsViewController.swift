//
//  SettingsViewController.swift
//  Spotify
//
//  Created by Abdelrahman on 02/05/2023.
//

import UIKit

class SettingsViewController: UIViewController {

    private let tableView:UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
    
    private var sections = [Section]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configureModels()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    private func configureModels(){
        sections.append(Section(title: "Profile", options: [Option(title: "View Your Profile", handler: {[weak self] in
            DispatchQueue.main.async{
                self?.viewProfile()
            }
        })]))
        
        sections.append(Section(title: "Account", options: [Option(title: "Sign Out", handler: {[weak self] in
            DispatchQueue.main.async{
                self?.signOutTapped()
            }
        })]))
    }
    
    private func viewProfile(){
        let vc = ProfileViewController()
        vc.title = "Profile"
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func signOutTapped(){
        let alert = UIAlertController(title: "Sign Out", message: "Are you really want to sign out?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "yes", style: .default,handler: { action in
            AuthManager.shared.signOUT { [weak self] success in
                if success{
                    DispatchQueue.main.async {
                        
                        let navVc = UINavigationController(rootViewController: WelcomeViewController())
                        navVc.navigationBar.prefersLargeTitles = true
                        navVc.viewControllers.first?.navigationItem.largeTitleDisplayMode = .always
                        navVc.modalPresentationStyle = .fullScreen
                        self?.present(navVc,animated: true,completion: {
                            self?.navigationController?.popToRootViewController(animated: false)
                        })
                        //navigationController?.pushViewController(navVc, animated: true)
                    }
                }
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .destructive))
        
        present(alert,animated: true)
    }
    
    
   
    private func setupUI(){
        title = "Settings"
        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
    }

   

}
// MARK: - TableView
extension SettingsViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        sections[section].options.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        sections.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = sections[indexPath.section].options[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = model.title
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let model = sections[indexPath.section].options[indexPath.row]
        model.handler()
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let model = sections[section]
        return model.title
    }
    
    
}
