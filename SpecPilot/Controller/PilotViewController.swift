//
//  PilotViewController.swift
//  SpecPilot
//
//  Created by David Dubez on 08/06/2019.
//  Copyright © 2019 David Dubez. All rights reserved.
//

import UIKit
import CoreBluetooth

class PilotViewController: UIViewController {

    // MARK: - IBOutlet
    @IBOutlet weak var setupButtonItem: UIBarButtonItem!
    @IBOutlet weak var connectedStatusImage: UIImageView!
    @IBOutlet weak var transfertActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var sendSettingButton: UIButton!
    @IBOutlet weak var readSettingButton: UIButton!

    @IBOutlet weak var feedPumpCycleTimeLabel: UILabel!
    @IBOutlet weak var feedPumpCycleTimeSlider: UISlider!
    @IBOutlet weak var feedPumpOnTimeLabel: UILabel!
    @IBOutlet weak var feedPumpOnTimeSlider: UISlider!
    @IBOutlet weak var feedPumpTotalTimeLabel: UILabel!
    @IBOutlet weak var feedPumpDailyVolumeLabel: UILabel!
    @IBOutlet weak var calculatedeffluentFlowRateLabel: UILabel!

    @IBOutlet weak var recyclPumpCycleTimeLabel: UILabel!
    @IBOutlet weak var recyclPumpCycleTimeSlider: UISlider!
    @IBOutlet weak var recyclPumpOnTimeLabel: UILabel!
    @IBOutlet weak var recyclPumpOnTimeSlider: UISlider!
    @IBOutlet weak var recyclPumpTotalTimeLabel: UILabel!
    @IBOutlet weak var recirculationRateLabel: UILabel!

    @IBOutlet weak var scraperRotationSpeedLabel: UILabel!
    @IBOutlet weak var scraperRotationSpeedSlider: UISlider!
    @IBOutlet weak var scraperPauseTimeLabel: UILabel!
    @IBOutlet weak var scraperPauseTimeSlider: UISlider!

    // MARK: - IBAction
    @IBAction func didTapSendSettingsButton(_ sender: UIButton) {
        testToggle()
    }
    @IBAction func didTapReadSettingsButton(_ sender: UIButton) {
        testToggle()
    }
    @IBAction func feedPumpCycleTimeValueChanged(_ sender: UISlider) {
        pilot.feedPump.cycleTimeInS = Double(feedPumpCycleTimeSlider.value.rounded()) * 30
        if pilot.feedPump.onTimeInS > pilot.feedPump.cycleTimeInS {
            pilot.feedPump.onTimeInS = pilot.feedPump.cycleTimeInS
        }
        feedPumpOnTimeSlider.maximumValue = feedPumpCycleTimeSlider.value.rounded()
        updateView()
    }
    @IBAction func feedPumpOnTimeValueChanged(_ sender: UISlider) {
        pilot.feedPump.onTimeInS = Double(feedPumpOnTimeSlider.value.rounded()) * 30
        updateView()
    }
    @IBAction func recyclPumpCycleTimeValueChanged(_ sender: UISlider) {
        pilot.recyclPump.cycleTimeInS = Double(recyclPumpCycleTimeSlider.value.rounded()) * 30
        if pilot.recyclPump.onTimeInS > pilot.recyclPump.cycleTimeInS {
            pilot.recyclPump.onTimeInS = pilot.recyclPump.cycleTimeInS
        }
        recyclPumpOnTimeSlider.maximumValue = recyclPumpCycleTimeSlider.value.rounded()
        updateView()
    }
    @IBAction func recyclPumpOnTimeValueChanged(_ sender: UISlider) {
        pilot.recyclPump.onTimeInS = Double(recyclPumpOnTimeSlider.value.rounded()) * 30
        updateView()
    }
    @IBAction func scraperRotationSpeedValueChanged(_ sender: UISlider) {
        pilot.scraper.rotationSpeedInRpm = Double(scraperRotationSpeedSlider.value.rounded())
        updateView()
    }
    @IBAction func scraperPauseTimeValueChanged(_ sender: UISlider) {
        pilot.scraper.pauseTimeInS = Double(scraperPauseTimeSlider.value.rounded()) * 30
        updateView()
    }

    // MARK: - Properties
    var timerTXDelay: Timer?
    var allowTX = true
    var lastPosition: UInt8 = 255
    var pilot = Pilot(name: "Pilote Spec")

    // MARK: - Override functions
    override func viewDidLoad() {
        super.viewDidLoad()

        connectedStatusImage.image = UIImage(named: "Disconnected")
        toggleCommunicationButtons(communicating: false)

        // Watch Bluetooth connection
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(PilotViewController.connectionChanged(_:)),
                                               name: NSNotification.Name(rawValue: BLEServiceChangedStatusNotification),
                                               object: nil)

        // Start the Bluetooth discovery process
        _ = bleDiscoverySharedInstance
    }

    deinit {
        NotificationCenter.default.removeObserver(self,
                                            name: NSNotification.Name(rawValue: BLEServiceChangedStatusNotification),
                                            object: nil)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateView()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.stopTimerTXDelay()
    }

    // MARK: - Functions

    private func updateView() {
        feedPumpCycleTimeLabel.text = formatDiplayedNumberWithUnit(pilot.feedPump.cycleTimeInS, unit: " s")
        feedPumpCycleTimeSlider.value = Float(pilot.feedPump.cycleTimeInS / 30)
        feedPumpOnTimeLabel.text = formatDiplayedNumberWithUnit(pilot.feedPump.onTimeInS, unit: " s")
        feedPumpOnTimeSlider.value = Float(pilot.feedPump.onTimeInS / 30)
        feedPumpTotalTimeLabel.text = formatDiplayedNumberWithUnit(pilot.feedPump.dailyTotalTimeInH, unit: " h")
        feedPumpDailyVolumeLabel.text = formatDiplayedNumberWithUnit(pilot.feedPump.dailyVolumeInL, unit: " l")

        if let calculedFlowRate = DesignCalculation.shared.effluentsFlowRateInLJ {
            calculatedeffluentFlowRateLabel.text = formatDiplayedNumberWithUnit(calculedFlowRate, unit: " l/j")
        } else {
            calculatedeffluentFlowRateLabel.text = "-"
        }

        recyclPumpCycleTimeLabel.text = formatDiplayedNumberWithUnit(pilot.recyclPump.cycleTimeInS, unit: " s")
        recyclPumpCycleTimeSlider.value = Float(pilot.recyclPump.cycleTimeInS / 30)
        recyclPumpOnTimeLabel.text = formatDiplayedNumberWithUnit(pilot.recyclPump.onTimeInS, unit: " s")
        recyclPumpOnTimeSlider.value = Float(pilot.recyclPump.onTimeInS / 30)
        recyclPumpTotalTimeLabel.text = formatDiplayedNumberWithUnit(pilot.recyclPump.dailyTotalTimeInH, unit: " h")
        recirculationRateLabel.text = formatDiplayedNumberWithUnit(pilot.recirculationRate, unit: " %")

        scraperRotationSpeedLabel.text = formatDiplayedNumberWithUnit(pilot.scraper.rotationSpeedInRpm, unit: " t/min")
        scraperRotationSpeedSlider.value = Float(pilot.scraper.rotationSpeedInRpm)
        scraperPauseTimeLabel.text = formatDiplayedNumberWithUnit(pilot.scraper.pauseTimeInS, unit: " s")
        scraperPauseTimeSlider.value = Float(pilot.scraper.pauseTimeInS / 30)
    }

    private func toggleCommunicationButtons(communicating: Bool) {
        transfertActivityIndicator.isHidden = !communicating
        sendSettingButton.isHidden = communicating
        readSettingButton.isHidden = communicating
    }

    private func formatDiplayedNumberWithUnit(_ number: Double, unit: String) -> String? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal

        if let formattedNumber = formatter.string(from: NSNumber(value: number)) {
            return formattedNumber + unit
        } else {
            return nil
        }
    }
}

// MARK: - Navigation
extension PilotViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToSetup" {
            if let setupVC = segue.destination as? SetupViewController {
                setupVC.pilot = pilot
            }
        }
    }
}
// MARK: - BLE manager
extension PilotViewController {
    @objc func timerTXDelayElapsed() {
        self.allowTX = true
        self.stopTimerTXDelay()
        self.toggleCommunicationButtons(communicating: false)
    }

    func sendSettings(_ position: UInt8) {
        if !allowTX {
            return
        }

        if position == lastPosition {
            return
        } else if position < 0 || position > 180 {
            return
        }

        if let bleService = bleDiscoverySharedInstance.bleService {
            toggleCommunicationButtons(communicating: true)
            print("sendposition")
            bleService.writePosition(position)
            lastPosition = position

            allowTX = false
            if timerTXDelay == nil {
                timerTXDelay = Timer.scheduledTimer(timeInterval: 1.0,
                                                    target: self,
                                                    selector: #selector(PilotViewController.timerTXDelayElapsed),
                                                    userInfo: nil,
                                                    repeats: false)
            }
        }
    }

    func testToggle() {
        if !allowTX {
            return
        }
        toggleCommunicationButtons(communicating: true)
        if timerTXDelay == nil {
            timerTXDelay = Timer.scheduledTimer(timeInterval: 1.0,
                                                target: self,
                                                selector: #selector(PilotViewController.timerTXDelayElapsed),
                                                userInfo: nil,
                                                repeats: false)
        }
    }

    func stopTimerTXDelay() {
        if self.timerTXDelay == nil {
            return
        }

        timerTXDelay?.invalidate()
        self.timerTXDelay = nil
    }

    @objc func connectionChanged(_ notification: Notification) {
        // Connection status changed. Indicate on GUI.
        guard let userInfo = (notification as NSNotification).userInfo as? [String: Bool] else {
            return
        }

        DispatchQueue.main.async(execute: {
            // Set image based on connection status
            if let isConnected: Bool = userInfo["isConnected"] {
                if isConnected {
                    self.connectedStatusImage.image = UIImage(named: "Connected")

                    // Send current slider position
                    //                    self.sendPosition(UInt8( self.revolutionSpeedScraperOneSlider.value))
                } else {
                    self.connectedStatusImage.image = UIImage(named: "Disconnected")
                }
            }
        })
    }
}
// TODO:    - envoie position
//          - supprimer le testToggle et test avec le toggle avec l'envoie des reglages
