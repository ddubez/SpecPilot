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
    @IBOutlet weak var revolutionSpeedScraperOneSlider: UISlider!
    @IBOutlet weak var connectedStatusImage: UIImageView!

    // MARK: - IBAction
    @IBAction func revolutionSpeedScraperOneSliderChanged(_ sender: UISlider) {
        self.sendPosition(UInt8(sender.value))
    }

    // MARK: - Properties
    var timerTXDelay: Timer?
    var allowTX = true
    var lastPosition: UInt8 = 255

    // MARK: - Override functions
    override func viewDidLoad() {
        super.viewDidLoad()
        connectedStatusImage.image = UIImage(named: "Disconnected")

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

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.stopTimerTXDelay()
    }

    // MARK: - Functions
    @objc func timerTXDelayElapsed() {
        self.allowTX = true
        self.stopTimerTXDelay()

        // Send current slider position
        self.sendPosition(UInt8(self.revolutionSpeedScraperOneSlider.value))
    }

    func sendPosition(_ position: UInt8) {
        if !allowTX {
            return
        }

        if position == lastPosition {
            return
        } else if position < 0 || position > 180 {
            return
        }

        if let bleService = bleDiscoverySharedInstance.bleService {
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
                    self.sendPosition(UInt8( self.revolutionSpeedScraperOneSlider.value))
                } else {
                    self.connectedStatusImage.image = UIImage(named: "Disconnected")
                }
            }
        })
    }
}

// TODO: gestion du clavier
