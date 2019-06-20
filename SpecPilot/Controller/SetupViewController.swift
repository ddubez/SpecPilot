//
//  SetupViewController.swift
//  SpecPilot
//
//  Created by David Dubez on 19/06/2019.
//  Copyright © 2019 David Dubez. All rights reserved.
//

import UIKit

class SetupViewController: UIViewController {

    // MARK: - PROPERTIES
    var pilot: Pilot!

    // MARK: - IBOutlet
    @IBOutlet weak var feedPumpFlowRateTextField: UITextField!
    @IBOutlet weak var recyclPumpFlowRateTextField: UITextField!
    @IBOutlet weak var pilotNameLabel: UILabel!

    // MARK: - Override functions
    override func viewDidLoad() {
        super.viewDidLoad()

        feedPumpFlowRateTextField.text = "\(pilot.feedPump.flowRateInLH)"
        recyclPumpFlowRateTextField.text = "\(pilot.recyclPump.flowRateInLH)"
        pilotNameLabel.text = pilot.name

    }
}

// MARK: - Navigation
extension SetupViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToSetup" {
            if let pilotVC = segue.destination as? PilotViewController {
                pilotVC.pilot.feedPump.flowRateInLH = pilot.feedPump.flowRateInLH
                pilotVC.pilot.recyclPump.flowRateInLH = pilot.recyclPump.flowRateInLH
            }
        }
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
            pilot.feedPump.flowRateInLH = feedPumpFlowRateTextFieldNumber
        }
        if let recyclPumpFlowRateTextFieldNumber = Double(self.recyclPumpFlowRateTextField.text!) {
            pilot.recyclPump.flowRateInLH = recyclPumpFlowRateTextFieldNumber
        }

        feedPumpFlowRateTextField.resignFirstResponder()
        recyclPumpFlowRateTextField.resignFirstResponder()
    }
}
// TODO:    - gerer le nom du pilote ou le choix du truc connecté
