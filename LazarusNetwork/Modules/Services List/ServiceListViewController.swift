//
//  ServiceListViewController.swift
//  LazarusNetwork
//
//  Created by Melany Gulianovych on 08.05.2020.
//  Copyright © 2020 Melany Gulianovych. All rights reserved.
//

import UIKit

protocol ServiceListViewControllable: ViewController {
    func setTitle(title: String)
    func reloadTable()
}

class ServiceListViewController: BaseViewController {
    @IBOutlet fileprivate weak var tableView: UITableView!
    
    private let cellIdentifier = ServiceTableViewCell.reuseIdentifier
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier)
        
    }
}

extension ServiceListViewController: UITableViewDataSource {
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

extension ServiceListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        currentPresenter.item(selectedAtIndex: indexPath.row)
    }
}

extension ServiceListViewController: ServiceListViewControllable {
    func reloadTable() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func setTitle(title: String) {
        navigationBar?.title = title
    }
}

extension ServiceListViewController: ViewControllerWithDefinedPresenter {
    typealias CurrentPresenter = ServiceListPresentable
}
