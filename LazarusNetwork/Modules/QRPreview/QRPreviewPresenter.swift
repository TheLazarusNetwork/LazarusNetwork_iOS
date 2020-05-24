//
//  QRPreviewPresenter.swift
//  LazarusNetwork
//
//  Created by Melany Gulianovych on 24.05.2020.
//  Copyright © 2020 Melany Gulianovych. All rights reserved.
//

import UIKit

protocol QRPreviewPresentable: Presenter {
    var controller: QRPreviewViewControllable? { get set }

    func closeScreen()
}

class QRPreviewPresenter: QRPreviewPresentable {
    weak var controller: QRPreviewViewControllable?
    var close: (() -> Void)?
    
    let qrString: String
    
    init(_ qrString: String) {
        self.qrString = qrString
    }
    
    func viewLoaded() {
        let image = generateQRCode(from: qrString)
        controller?.showQRImage(qrCodeImage: image ?? UIImage())
    }

    func closeScreen() {
        close?()
    }
    
    func generateQRCode(from string: String) -> UIImage? {
        let data = string.data(using: String.Encoding.ascii)

        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            let transform = CGAffineTransform(scaleX: 3, y: 3)

            if let output = filter.outputImage?.transformed(by: transform) {
                return UIImage(ciImage: output)
            }
        }

        return nil
    }

}
