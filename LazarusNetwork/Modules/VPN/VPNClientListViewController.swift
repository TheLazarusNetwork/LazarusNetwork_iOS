//
//  VPNClientListViewController.swift
//  LazarusNetwork
//
//  Created by Melany Gulianovych on 08.05.2020.
//  Copyright © 2020 Melany Gulianovych. All rights reserved.
//

import UIKit
protocol VPNClientListViewControllable: ViewController {
    func setTitle(title: String)
    func reloadTable()
    func updateMainInfo(message: String)
    func hideAddClientButton()
}

class VPNClientListViewController: BaseViewController {
    @IBOutlet fileprivate weak var tableView: UITableView!
    
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var messageView: UIView!
    
    @IBOutlet weak var addClientView: UIView!
    
    private let cellIdentifier = ClientTableViewCell.reuseIdentifier
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier)
    }
    
    @IBAction func addClientPressed(_ sender: Any) {
        currentPresenter.addClientSelected()
    }
}

extension VPNClientListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentPresenter.itemsCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        fill(cell: cell, atIndex: indexPath.row)
        
        return cell
    }
    
    private func fill(cell: UITableViewCell, atIndex index: Int) {
        guard let cell = cell as? PlainModelFillable else {
            return
        }
        
        currentPresenter.fill(item: cell, atIndex: index)
    }
}

extension VPNClientListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        currentPresenter.item(selectedAtIndex: indexPath.row)
    }
}

extension VPNClientListViewController: VPNClientListViewControllable {
    func reloadTable() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func setTitle(title: String) {
        navigationBar?.title = title
    }
    
    func updateMainInfo(message: String) {
        DispatchQueue.main.async {
            self.messageLabel.text = message
            self.messageView.isHidden = false
        }
    }
    
    func hideAddClientButton() {
        DispatchQueue.main.async {
            self.addClientView.isHidden = true
        }
    }
}

extension VPNClientListViewController: ViewControllerWithDefinedPresenter {
    typealias CurrentPresenter = VPNClientListPresentable
}
