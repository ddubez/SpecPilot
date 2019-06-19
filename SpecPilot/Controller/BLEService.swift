//
//  BLEService.swift
//  SpecPilot
//
//  Created by David Dubez on 09/06/2019.
//  Copyright © 2019 David Dubez. All rights reserved.
//

import Foundation
import CoreBluetooth

/* Services & Characteristics UUIDs */

let pilotSpecServiceCBUUID = CBUUID(string: "0x1234")
let writeWithoutResponseCharasteristicCBUUID = CBUUID(string: "1235")
let notifyCharasteristicCBUUID = CBUUID(string: "1236")

//let BLEServiceUUID = CBUUID(string: "025A7775-49AA-42BD-BBDB-E2AE77782966")
//let positionCharUUID = CBUUID(string: "F38A2C23-BC54-40FC-BED0-60EDDA139F47")
let BLEServiceChangedStatusNotification = "kBLEServiceChangedStatusNotification"

class BLEService: NSObject, CBPeripheralDelegate {
    var peripheral: CBPeripheral?
    var positionCharacteristic: CBCharacteristic?

    init(initWithPeripheral peripheral: CBPeripheral) {
        super.init()

        self.peripheral = peripheral
        self.peripheral?.delegate = self
    }

    deinit {
        self.reset()
    }

    func startDiscoveringServices() {
        self.peripheral?.discoverServices([pilotSpecServiceCBUUID])
    }

    func reset() {
        if peripheral != nil {
            peripheral = nil
        }

        // Deallocating therefore send notification
        self.sendBTServiceNotificationWithIsBluetoothConnected(false)
    }

    // MARK: - CBPeripheralDelegate

    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        let uuidsForBTService: [CBUUID] = [writeWithoutResponseCharasteristicCBUUID]

        if peripheral != self.peripheral {
            // Wrong Peripheral
            return
        }

        if error != nil {
            return
        }

        if (peripheral.services == nil) || (peripheral.services!.count == 0) {
            // No Services
            return
        }

        for service in peripheral.services! where service.uuid == pilotSpecServiceCBUUID {
            peripheral.discoverCharacteristics(uuidsForBTService, for: service)
        }
    }

    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        if peripheral != self.peripheral {
            // Wrong Peripheral
            return
        }

        if error != nil {
            return
        }

        if let characteristics = service.characteristics {
            for characteristic in characteristics where
                characteristic.uuid == writeWithoutResponseCharasteristicCBUUID {
                    self.positionCharacteristic = (characteristic)
                    peripheral.setNotifyValue(true,
                                              for: characteristic)

                    // Send notification that Bluetooth is connected and all required characteristics are discovered
                    self.sendBTServiceNotificationWithIsBluetoothConnected(true)
            }
        }
    }

    // MARK: - Private
    func writePosition(_ position: UInt8) {
        // See if characteristic has been discovered before writing to it
        if let positionCharacteristic = self.positionCharacteristic {
            let data = Data(_: [position])
            self.peripheral?.writeValue(data, for: positionCharacteristic, type: CBCharacteristicWriteType.withResponse)
            print("dddddd")
            print(position)
        }
    }

    func sendBTServiceNotificationWithIsBluetoothConnected(_ isBluetoothConnected: Bool) {
        let connectionDetails = ["isConnected": isBluetoothConnected]
        NotificationCenter.default.post(name: Notification.Name(rawValue: BLEServiceChangedStatusNotification),
                                        object: self, userInfo: connectionDetails)
    }

}

// TODO:    - tests à faire
//          - Voir problème com
// TODO:    - Verif comportement gitignore
