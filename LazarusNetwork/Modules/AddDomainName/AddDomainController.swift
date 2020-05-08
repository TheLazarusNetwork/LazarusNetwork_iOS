//
//  AddDomainController.swift
//  LazarusNetwork
//
//  Created by Melany Gulianovych on 07.05.2020.
//  Copyright © 2020 Melany Gulianovych. All rights reserved.
//

import UIKit

protocol AddDomainControllable: ViewController {
    func setTitle(title: String)
    func setUpMainTitles(name: String, email: String, region: String, type: String)
    func show(errors:[AddDomainErrorType])
    func showSuccessMessage(message: String, title: String)
    func showSelectableDialog(with title: String, sectionType: DomainSectionType, selectionType: SelectableViewType, models:[SelectableItemModel])
    func populateSection(_ section: DomainSectionType, with value: String)
    func closeScreen()
}

class AddDomainController: BaseViewController {
    @IBOutlet weak var domainNameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var regionLabel: UILabel!
    
    @IBOutlet weak var domainNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var selectTypeTextField: UITextField!
    @IBOutlet weak var selectRegionTextField: UITextField!
    
    @IBOutlet weak var domainNameErrorLabel: UILabel!
    @IBOutlet weak var emailErrorLabel: UILabel!
    @IBOutlet weak var typeErrorLabel: UILabel!
    @IBOutlet weak var regionErrorLabel: UILabel!
    
    @IBOutlet weak var saveButton: UIButton!
    
    private let cellIdentifier = DomainTableViewCell.reuseIdentifier
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        hideKeyboardWhenTappedAround()
    }
    
    @IBAction func selectTypePressed(_ sender: Any) {
        currentPresenter.plansPresent()
    }
    
    @IBAction func selectRegionPressed(_ sender: Any) {
        currentPresenter.regionsPresent()
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        currentPresenter.save()
    }
}

extension AddDomainController: AddDomainControllable {
    func setTitle(title: String) {
        navigationBar?.title = title
    }
    
    func setUpMainTitles(name: String, email: String, region: String, type: String) {
        domainNameLabel.text = name
        emailLabel.text = email
        typeLabel.text = type
        regionLabel.text = region
    }
    
    func show(errors:[AddDomainErrorType]) {
        domainNameErrorLabel.isHidden = true
        emailErrorLabel.isHidden = true
        typeErrorLabel.isHidden = true
        regionErrorLabel.isHidden = true
        
        for error in errors {
            switch error {
            case .name:
                domainNameErrorLabel.text = error.errorDescription
                domainNameErrorLabel.isHidden = false
                
            case .email:
                emailErrorLabel.text = error.errorDescription
                emailErrorLabel.isHidden = false
                
            case .type:
                typeErrorLabel.text = error.errorDescription
                typeErrorLabel.isHidden = false
                
            case .region:
                regionErrorLabel.text = error.errorDescription
                regionErrorLabel.isHidden = false
            }
        }
    }
    
    func showSuccessMessage(message: String, title: String) {
        DispatchQueue.main.async { [weak currentPresenter] in
            let alert = AlertView(
                withTitle: title,
                andContent: message
            )
            
            alert.add(
                AlertViewAction(
                    buttonName: Constants.Strings.ok,
                    with: { [weak currentPresenter] in
                        currentPresenter?.closeScreen()
                    }
                )
            )
            
            alert.present(on: self)
        }
    }
    
    func showSelectableDialog(with title: String,
                              sectionType: DomainSectionType,
                              selectionType: SelectableViewType,
                              models:[SelectableItemModel]) {
        DispatchQueue.main.async {
            let dialog = SelectableDialog(with: title,
                                          type: selectionType,
                                          models: models) { [weak self] (selectedItems) in
                                            guard let selectableItems = selectedItems else {
                                                return
                                            }
                                            self?.currentPresenter.selectedItems(selectableItems, type: sectionType)
            }
            dialog.present(on: self)
        }
    }
    
    func populateSection(_ section: DomainSectionType, with value: String) {
        switch section {
        case .plan:
            selectTypeTextField.text = value
            typeErrorLabel.isHidden = true
            
        case .region:
            selectRegionTextField.text = value
            regionErrorLabel.isHidden = true
        }
    }

    
    func closeScreen() {
        leftActionSelected(with: self)
    }
}

extension AddDomainController: ViewControllerWithDefinedPresenter {
    typealias CurrentPresenter = AddDomainPresentable
}

extension AddDomainController: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == domainNameTextField {
            currentPresenter.updateDomainName(textField.text ?? .empty)
        } else if textField == emailTextField {
            currentPresenter.updateEmail(textField.text ?? .empty)
        }
    }
}
