//
//  BLEDiscoveryService.swift
//  SpecPilot
//
//  Created by David Dubez on 10/06/2019.
//  Copyright © 2019 David Dubez. All rights reserved.
//

import Foundation
import CoreBluetooth

let bleDiscoverySharedInstance = BLEDiscoveryService()

class BLEDiscoveryService: NSObject, CBCentralManagerDelegate {

    fileprivate var centralManager: CBCentralManager?
    fileprivate var peripheralBLE: CBPeripheral?

    override init() {
        super.init()

        let centralQueue = DispatchQueue(label: "fr.daviddubez", attributes: [])
        centralManager = CBCentralManager(delegate: self, queue: centralQueue)
    }

    func startScanning() {
        if let central = centralManager {
            central.scanForPeripherals(withServices: [pilotSpecServiceCBUUID], options: nil)
        }
    }

    var bleService: BLEService? {
        didSet {
            if let service = self.bleService {
                service.startDiscoveringServices()
            }
        }
    }

    // MARK: - CBCentralManagerDelegate

    func centralManager(_ central: CBCentralManager,
                        didDiscover peripheral: CBPeripheral,
                        advertisementData: [String: Any],
                        rssi RSSI: NSNumber) {
        // Be sure to retain the peripheral or it will fail during connection.
        print(peripheral)
        // Validate peripheral information
        if (peripheral.name == nil) || (peripheral.name == "") {
            return
        }

        // If not already connected to a peripheral, then connect to this one
        if (self.peripheralBLE == nil) || (self.peripheralBLE?.state == CBPeripheralState.disconnected) {
            // Retain the peripheral before trying to connect
            self.peripheralBLE = peripheral

            // Reset service
            self.bleService = nil

            // Connect to peripheral
            central.connect(peripheral, options: nil)
        }
    }

    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {

        // Create new service class
        if peripheral == self.peripheralBLE {
            print("connected !")
            self.bleService = BLEService(initWithPeripheral: peripheral)
        }

        // Stop scanning for new devices
        central.stopScan()
    }

    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {

        // See if it was our peripheral that disconnected
        if peripheral == self.peripheralBLE {
            self.bleService = nil
            self.peripheralBLE = nil
        }

        // Start scanning for new devices
        self.startScanning()
    }

    // MARK: - Private

    func clearDevices() {
        self.bleService = nil
        self.peripheralBLE = nil
    }

    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .poweredOff:
            print("central.state is .poweredOff")
            self.clearDevices()
        case .unauthorized:
            // Indicate to user that the iOS device does not support BLE.
            print("central.state is .unauthorized")
        case .unknown:
            // Wait for another event
            print("central.state is .unknown")
        case .poweredOn:
            print("central.state is .poweredOn")
            self.startScanning()
        case .resetting:
            print("central.state is .resetting")
            self.clearDevices()
        case .unsupported:
            print("central.state is .unsupported")
        @unknown default:
            print("central.state is .unknown default")
        }
    }

}

// TODO: tests à faire
