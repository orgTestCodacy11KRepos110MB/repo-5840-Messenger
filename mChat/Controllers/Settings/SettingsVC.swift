//
//  SettingsVC.swift
//  mChat
//
//  Created by Vitaliy Paliy on 11/17/19.
//  Copyright © 2019 PALIY. All rights reserved.
//

import UIKit
import Firebase

class SettingsVC: UIViewController {
    
    var leftBarButton = UIBarButtonItem()
    var tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Settings"
        view.backgroundColor = .white
        setupTableView()
        setupLeftNavButton()
        
    }
    
    func setupLeftNavButton(){
        leftBarButton = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(logoutButtonPressed))
        navigationItem.setLeftBarButton(leftBarButton, animated: true)
    }
    
    func setupTableView(){
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 100
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.register(ProfileCell.self, forCellReuseIdentifier: "ProfileCell")
        let constraints = [
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    @objc func logoutButtonPressed(){
        do{
            try Auth.auth().signOut()
            let controller = SignInVC()
            view.window?.rootViewController = controller
            view.window?.makeKeyAndVisible()
        }catch{
            showAlert(title: "Error", message: error.localizedDescription)
        }
        
    }
    
}

extension SettingsVC: UITableViewDelegate, UITableViewDataSource {
    
// TODO: Add Appearence etc.
//    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
//        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 35))
//        footerView.backgroundColor = UIColor(white: 0.90, alpha: 1)
//        return footerView
//    }
//
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 3
//    }
//
//    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//        return 35
//    }
//
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileCell") as! ProfileCell
        cell.emailLabel.text = CurrentUser.email
        cell.nameLabel.text = CurrentUser.name
        cell.profileImage.loadImage(url: CurrentUser.profileImage)
        return cell
    }
    
    
}