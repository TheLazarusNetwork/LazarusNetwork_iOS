//
//  ClientDetailViewController.swift
//  LazarusNetwork
//
//  Created by Melany Gulianovych on 17.05.2020.
//  Copyright © 2020 Melany Gulianovych. All rights reserved.
//

import UIKit

protocol ClientDetailViewControllable: ViewController {
    func setTitle(title: String)
    func showSuccessMessage(message: String, title: String)
    func updateTitles(name: String,
                      email: String,
                      clientIP: String,
                      allowedIPs: String,
                      enableClient: String,
                      ignoreKeepalive: String)
    
    func populateWithData(name: String,
                          email: String,
                          clientIP: String,
                          allowedIPs: String,
                          isEnabled: Bool,
                          isIgnore: Bool)
    func show(errors:[AddDomainErrorType])
}

class ClientDetailViewController: BaseViewController {
    @IBOutlet weak var clientNameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var clientIPLabel: UILabel!
    @IBOutlet weak var allowedIPsLabel: UILabel!
    @IBOutlet weak var enableClientLabel: UILabel!
    @IBOutlet weak var ignoreKeepaliveLabel: UILabel!

    @IBOutlet weak var clientNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var clientIPTextField: UITextField!
    @IBOutlet weak var allowedIPsTextField: UITextField!
    
    @IBOutlet weak var enableClientSwitch: UISwitch!
    @IBOutlet weak var ignoreKeepaliveSwitch: UISwitch!
    
    @IBOutlet weak var clientNameErrorLabel: UILabel!
    @IBOutlet weak var emailErrorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        enableClientSwitch.addTarget(self, action: #selector(enableClientValueChanged), for: .valueChanged)
        ignoreKeepaliveSwitch.addTarget(self, action: #selector(ignoreKeepaliveValueChanged), for: .valueChanged)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        hideKeyboardWhenTappedAround()
    }
    
    @objc func enableClientValueChanged(switchState: UISwitch) {
        currentPresenter.enabledClientStatusChanged(switchState.isOn)
    }
    
    @objc func ignoreKeepaliveValueChanged(switchState: UISwitch) {
        currentPresenter.ignoreKeepaliveStatusChanged(switchState.isOn)
    }
        
    @IBAction func saveButtonPressed(_ sender: Any) {
        currentPresenter.save()
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        currentPresenter.closeScreen()
    }
}

extension ClientDetailViewController: ViewControllerWithDefinedPresenter {
    typealias CurrentPresenter = ClientDetailPresentable
}

extension ClientDetailViewController: ClientDetailViewControllable {
    func setTitle(title: String) {
        navigationBar?.title = title
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
    
    func updateTitles(name: String,
                      email: String,
                      clientIP: String,
                      allowedIPs: String,
                      enableClient: String,
                      ignoreKeepalive: String) {
        clientIPLabel.text = name
        emailLabel.text = email
        clientIPLabel.text = clientIP
        allowedIPsLabel.text = allowedIPs
        enableClientLabel.text = enableClient
        ignoreKeepaliveLabel.text = ignoreKeepalive
    }
    
    func populateWithData(name: String,
                          email: String,
                          clientIP: String,
                          allowedIPs: String,
                          isEnabled: Bool,
                          isIgnore: Bool) {
        clientNameTextField.text = name
        emailTextField.text = email
        clientIPTextField.text = clientIP
        allowedIPsTextField.text = allowedIPs
        enableClientSwitch.isOn = isEnabled
        ignoreKeepaliveSwitch.isOn = isIgnore
    }
    
    func show(errors:[AddDomainErrorType]) {
        clientNameErrorLabel.isHidden = true
        emailErrorLabel.isHidden = true
        
        for error in errors {
            switch error {
            case .name:
                clientNameErrorLabel.text = error.errorDescription
                clientNameErrorLabel.isHidden = false
                
            case .email:
                emailErrorLabel.text = error.errorDescription
                emailErrorLabel.isHidden = false
                
            default:
                break
            }
        }
    }
}

extension ClientDetailViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == clientNameTextField {
            currentPresenter.updateClientName(textField.text ?? .empty)
        } else if textField == emailTextField {
            currentPresenter.updateEmail(textField.text ?? .empty)
        }
    }
}
