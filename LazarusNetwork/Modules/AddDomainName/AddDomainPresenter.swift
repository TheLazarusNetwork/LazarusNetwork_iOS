//
//  AddDomainPresenter.swift
//  LazarusNetwork
//
//  Created by Melany Gulianovych on 07.05.2020.
//  Copyright © 2020 Melany Gulianovych. All rights reserved.
//

import UIKit

extension Constants.Strings {
    static let addDomainTitle = "Create domain".localized
    static let addName = "Enter domain name".localized
    static let addEmail = "Enter email".localized
    static let selectRegion = "Select region".localized
    static let selectType = "Select domain type".localized
    
    static let addNameError = "Please enter domain name".localized
    static let addEmailError = "Please enter email".localized
    static let selectRegionError = "Please select region".localized
    static let selectTypeError = "Please select domain type".localized
    
    static let planSelectionDialogTitle = "Please select plan".localized
    static let regionSelectionDialogTitle = "Please select region".localized
    
    static let successCreatingDomainTitle = "Success".localized
    static let successCreatingDomain = "Domain %@ was created".localized
}

enum AddDomainErrorType {
    case name
    case email
    case type
    case region
}

enum DomainSectionType {
    case plan
    case region
}

extension AddDomainErrorType {
    var errorDescription: String {
        switch self {
        case .name:
            return Constants.Strings.addNameError
            
        case .email:
            return Constants.Strings.addEmailError
            
        case .type:
            return Constants.Strings.selectTypeError
            
        case .region:
            return Constants.Strings.selectRegionError
        }
    }
}

protocol AddDomainPresentable: Presenter {
    var controller: AddDomainControllable? { get set }
    var close: (() -> Void)? { get set }
    
    func plansPresent()
    func regionsPresent()
    func selectedItems(_ items:[String], type: DomainSectionType)
    func updateDomainName(_ name: String)
    func updateEmail(_ email: String)
    func save()
    func closeScreen()
}

class AddDomainPresenter: AddDomainPresentable {
    weak var controller: AddDomainControllable?
    
    var close: (() -> Void)?
    var selectedPlan: String = .empty
    var selectedRegion: String = .empty
    var domainName: String = .empty
    var email: String = .empty
    
    private let model: AddDomainModellable
    
    init(with model: AddDomainModellable) {
        self.model = model
    }
    
    func viewLoaded() {
        controller?.showWaitingDialog()
        controller?.setTitle(title: Constants.Strings.addDomainTitle)
        controller?.setUpMainTitles(name: Constants.Strings.addName,
                                    email: Constants.Strings.addEmail,
                                    region: Constants.Strings.selectRegion,
                                    type: Constants.Strings.selectType)
        model.loadPlansAndRegions { [weak self] error in
            self?.controller?.removeWaitingDialog()
            if !error.isEmpty {
                self?.controller?.show(alertWithMessage: Constants.Strings.ok,
                                       andTitle: error)
            }
        }
    }
    
    func plansPresent() {
        controller?.showSelectableDialog(with: Constants.Strings.planSelectionDialogTitle,
                                         sectionType: .plan,
                                         selectionType: .singleSelection,
                                         models: generateSelectionModels(from: model.plans))
    }
    
    func regionsPresent() {
        controller?.showSelectableDialog(with: Constants.Strings.regionSelectionDialogTitle,
                                         sectionType: .region,
                                         selectionType: .singleSelection,
                                         models: generateSelectionModels(from: model.regions))
    }
    
    func selectedItems(_ items: [String], type: DomainSectionType) {
        let value = items.first ?? ""
        switch type {
        case .plan:
            selectedPlan = value

        case .region:
            selectedRegion = value
        }
        controller?.populateSection(type, with:value)
    }
    
    func updateDomainName(_ name: String) {
        domainName = name
    }
    
    func updateEmail(_ email: String) {
        self.email = email
    }
    
    func save() {
        guard validate(domainName: domainName, email: email, type: selectedPlan, region: selectedRegion) else {
            return
        }
        controller?.showWaitingDialog()
        model.createDomain(domainName: domainName,
                           email: email,
                           plan: selectedPlan,
                           region: selectedRegion) { [weak self] result, domain in
                            self?.controller?.removeWaitingDialog()
                            switch result {
                            case .error(let error):
                                self?.controller?.show(alertWithMessage: error, andTitle: Constants.Strings.errorTitle)
                                
                            case .emptySuccess(_), .success:
                                let message = Constants.Strings.successCreatingDomain.replacingOccurrences(of: "%@", with: domain?.domainName ?? .empty, options: NSString.CompareOptions.literal, range: nil)
                                self?.controller?.showSuccessMessage(message: message, title: Constants.Strings.successCreatingDomainTitle)
                            }
        }
    }
    
    func closeScreen() {
        close?()
    }
    
    func validate(domainName: String, email: String, type: String, region: String) -> Bool {
        var errors: [AddDomainErrorType] = []
        if domainName.isEmpty {
            errors.append(.name)
        }
        
        if email.isEmpty {
            errors.append(.email)
        }
        
        if type.isEmpty {
            errors.append(.type)
        }
        
        if region.isEmpty {
            errors.append(.region)
        }
        
        controller?.show(errors: errors)
        return errors.count == 0
    }
    
    private func generateSelectionModels(from items: [String]) -> [SelectableItemModel] {
        var models: [SelectableItemModel] = []
        for item in items {
            models.append(SelectableItemModel(name: item, isSelected: false))
        }
        return models
    }
}
