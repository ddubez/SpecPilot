//
//  DesignViewController.swift
//  SpecPilot
//
//  Created by David Dubez on 08/06/2019.
//  Copyright © 2019 David Dubez. All rights reserved.
//

import UIKit

class DesignViewController: UIViewController {

    // MARK: - IBOutlet
    @IBOutlet weak var massLoadInKgTextField: UITextField!
    @IBOutlet weak var effluentsDcoInmglTextField: UITextField!
    @IBOutlet weak var effluentsDcoDboTextField: UITextField!
    @IBOutlet weak var effluentsFlowRateInLJLabel: UILabel!
    @IBOutlet weak var effluentsDboInMglLabel: UILabel!
    @IBOutlet weak var mudSMInGlTextField: UITextField!
    @IBOutlet weak var mudMVSInPercentTextField: UITextField!
    @IBOutlet weak var mudVolumeInLTextField: UITextField!
    @IBOutlet weak var reactorMassMVSLabel: UILabel!

    // MARK: - IBAction
    @IBAction func didTapCalculation(_ sender: UIButton) {
        catchValues()
        updateValues()
    }

    // MARK: - Properties

    // MARK: - OverRide functions
    override func viewWillAppear(_ animated: Bool) {
        // Listen for keyBoard events
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillChange(notification:)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillChange(notification:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillChange(notification:)),
                                               name: UIResponder.keyboardWillChangeFrameNotification,
                                               object: nil)
    }

    // MARK: - Functions
    private func catchValues() {
        DesignCalculation.shared.massLoadInKg = convertTextInValue(massLoadInKgTextField.text!)
        DesignCalculation.shared.effluentsDcoInmgl = convertTextInValue(effluentsDcoInmglTextField.text!)
        DesignCalculation.shared.effluentsDcoDbo = convertTextInValue(effluentsDcoDboTextField.text!)
        DesignCalculation.shared.mudSMInGl = convertTextInValue(mudSMInGlTextField.text!)
        DesignCalculation.shared.mudMVSInPercent = convertTextInValue(mudMVSInPercentTextField.text!)
        DesignCalculation.shared.mudVolumeInL = convertTextInValue(mudVolumeInLTextField.text!)
    }

    private func updateValues() {
        if let designCalculationEffluentsDboInMgl = DesignCalculation.shared.effluentsDboInMgl {
            effluentsDboInMglLabel.text = formatDiplayedNumber(designCalculationEffluentsDboInMgl)
        } else {
            effluentsDboInMglLabel.text = "-"
        }

        if let designCalculationReactorMass = DesignCalculation.shared.reactorMass {
            reactorMassMVSLabel.text = formatDiplayedNumber(designCalculationReactorMass)
        } else {
            reactorMassMVSLabel.text = "-"
        }

        if let designCalculationEffluentsVolumeInL = DesignCalculation.shared.effluentsFlowRateInLJ {
            effluentsFlowRateInLJLabel.text = formatDiplayedNumber(designCalculationEffluentsVolumeInL)
        } else {
            effluentsFlowRateInLJLabel.text = "-"
        }
    }

    private func formatDiplayedNumber(_ number: Double) -> String? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal

        if let formattedNumber = formatter.string(from: NSNumber(value: number)) {
            return formattedNumber
        } else {
            return nil
        }
    }

    private func convertTextInValue(_ text: String) -> Double? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal

        if let formattedNumber = formatter.number(from: text) {
            return Double(truncating: formattedNumber)
        } else {
            return nil
        }
    }
}

// MARK: - KEYBOARD
extension DesignViewController: UITextFieldDelegate {
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        resignAllTextField()
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        resignAllTextField()
        return true
    }

    @objc func keyboardWillChange(notification: NSNotification) {
        // move the view when adding text in secondTextView
        if massLoadInKgTextField.isFirstResponder {
            return
        }
        if effluentsDcoInmglTextField.isFirstResponder {
            return
        }
        if effluentsDcoDboTextField.isFirstResponder {
            return
        }
        guard let keyboardRect =
            (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
                return
        }
        if notification.name == UIResponder.keyboardWillShowNotification ||
            notification.name == UIResponder.keyboardWillChangeFrameNotification {

            view.frame.origin.y = -keyboardRect.height
        } else {
            view.frame.origin.y = 0
        }
    }

    private func resignAllTextField() {
        massLoadInKgTextField.resignFirstResponder()
        effluentsDcoInmglTextField.resignFirstResponder()
        effluentsDcoDboTextField.resignFirstResponder()
        mudSMInGlTextField.resignFirstResponder()
        mudVolumeInLTextField.resignFirstResponder()
        mudMVSInPercentTextField.resignFirstResponder()
    }
}
