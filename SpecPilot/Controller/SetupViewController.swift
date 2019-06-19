//
//  SetupViewController.swift
//  SpecPilot
//
//  Created by David Dubez on 19/06/2019.
//  Copyright © 2019 David Dubez. All rights reserved.
//

import UIKit

class SetupViewController: UIViewController {

    // MARK: - IBOutlet
    @IBOutlet weak var feedPumpFlowRateTextField: UITextField!
    @IBOutlet weak var recyclPumpFlowRateTextField: UITextField!

    // MARK: - Override functions
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        feedPumpFlowRateTextField.text = "\(PilotSetting.shared.feedPumpFlowRate)"
        recyclPumpFlowRateTextField.text = "\(PilotSetting.shared.recyclPumpFlowRate)"
    }

}

// MARK: - KEYBOARD
extension SetupViewController: UITextFieldDelegate {
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        resignAllTextField()
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        resignAllTextField()
        return true
    }

    private func resignAllTextField() {

        if let feedPumpFlowRateTextFieldNumber = Double(self.feedPumpFlowRateTextField.text!) {
            PilotSetting.shared.feedPumpFlowRate = feedPumpFlowRateTextFieldNumber
        }
        if let recyclPumpFlowRateTextFieldNumber = Double(self.recyclPumpFlowRateTextField.text!) {
            PilotSetting.shared.recyclPumpFlowRate = recyclPumpFlowRateTextFieldNumber
        }

        feedPumpFlowRateTextField.resignFirstResponder()
        recyclPumpFlowRateTextField.resignFirstResponder()
    }
}
