//
//  DomainsListViewController.swift
//  LazarusNetwork
//
//  Created by Melany Gulianovych on 02.05.2020.
//  Copyright © 2020 Melany Gulianovych. All rights reserved.
//

import UIKit

protocol DomainsListViewControllable: ViewController {
    func reloadTable()
    
    func setTitle(title: String)
    func closeScreen()
}

class DomainsListViewController: BaseViewController {
    @IBOutlet fileprivate weak var tableView: UITableView!
    
    private let cellIdentifier = DomainTableViewCell.reuseIdentifier
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier)
        
    }
}

extension DomainsListViewController: UITableViewDataSource {
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

extension DomainsListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        currentPresenter.item(selectedAtIndex: indexPath.row)
    }
}

extension DomainsListViewController: DomainsListViewControllable {
    func reloadTable() {
        tableView.reloadData()
    }
    
    func setTitle(title: String) {
        navigationBar?.title = title
    }
    
    func closeScreen() {
        leftActionSelected(with: self)
    }
}

extension DomainsListViewController: ViewControllerWithDefinedPresenter {
    typealias CurrentPresenter = DomainsListPresentable
}
