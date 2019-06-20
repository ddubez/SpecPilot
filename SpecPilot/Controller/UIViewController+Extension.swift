//
//  UIViewController+Extension.swift
//  SpecPilot
//
//  Created by David Dubez on 20/06/2019.
//  Copyright © 2019 David Dubez. All rights reserved.
//

import Foundation
import UIKit

// MARK: - Alert
extension UIViewController {
    func displayAlert(with message: String) {
        let alert = UIAlertController(title: NSLocalizedString("Error!", comment: ""),
                                      message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
