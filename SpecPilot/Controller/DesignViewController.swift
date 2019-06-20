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
    @IBOutlet weak var effluentsVolumeInLLabel: UILabel!
    @IBOutlet weak var effluentsDboInMglLabel: UILabel!
    @IBOutlet weak var mudSMInGlTextField: UITextField!
    @IBOutlet weak var mudMVSInPercentTextField: UITextField!
    @IBOutlet weak var mudVolumeInLTextField: UITextField!
    @IBOutlet weak var reactorMassMVSLabel: UILabel!
    @IBOutlet weak var mudDcoInMglTextField: UITextField!

    // MARK: - IBAction
    @IBAction func didTapCalculation(_ sender: UIButton) {
        catchValues()
        updateValues()
    }

    // MARK: - Properties
    var designCalculation = DesignCalculation()

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
        designCalculation.massLoadInKg = convertTextInValue(massLoadInKgTextField.text!)
        designCalculation.effluentsDcoInmgl = convertTextInValue(effluentsDcoInmglTextField.text!)
        designCalculation.effluentsDcoDbo = convertTextInValue(effluentsDcoDboTextField.text!)
        designCalculation.mudSMInGl = convertTextInValue(mudSMInGlTextField.text!)
        designCalculation.mudMVSInPercent = convertTextInValue(mudMVSInPercentTextField.text!)
        designCalculation.mudVolumeInL = convertTextInValue(mudVolumeInLTextField.text!)
        designCalculation.mudDcoInMgl = convertTextInValue(mudDcoInMglTextField.text!)
    }

    private func updateValues() {
        if let designCalculationEffluentsDboInMgl = designCalculation.effluentsDboInMgl {
            effluentsDboInMglLabel.text = formatDiplayedNumber(designCalculationEffluentsDboInMgl)
        } else {
            effluentsDboInMglLabel.text = "-"
        }

        if let designCalculationReactorMass = designCalculation.reactorMass {
            reactorMassMVSLabel.text = formatDiplayedNumber(designCalculationReactorMass)
        } else {
            reactorMassMVSLabel.text = "-"
        }

        if let designCalculationEffluentsVolumeInL = designCalculation.effluentsVolumeInL {
            effluentsVolumeInLLabel.text = formatDiplayedNumber(designCalculationEffluentsVolumeInL)
        } else {
            effluentsVolumeInLLabel.text = "-"
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
        mudDcoInMglTextField.resignFirstResponder()
        mudMVSInPercentTextField.resignFirstResponder()
    }
}
