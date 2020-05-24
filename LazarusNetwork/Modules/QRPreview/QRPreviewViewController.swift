//
//  QRPreviewViewController.swift
//  LazarusNetwork
//
//  Created by Melany Gulianovych on 24.05.2020.
//  Copyright © 2020 Melany Gulianovych. All rights reserved.
//

import UIKit

protocol QRPreviewViewControllable: ViewController {
    func showQRImage(qrCodeImage: UIImage)
}

class QRPreviewViewController: BaseViewController {
    @IBOutlet weak var qrImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func closeButtonTapped(_ sender: Any) {
        currentPresenter.closeScreen()
    }
}

extension QRPreviewViewController: ViewControllerWithDefinedPresenter {
    typealias CurrentPresenter = QRPreviewPresentable
}

extension QRPreviewViewController: QRPreviewViewControllable {
    func showQRImage(qrCodeImage: UIImage) {
        qrImageView.image = qrCodeImage
    }
}
