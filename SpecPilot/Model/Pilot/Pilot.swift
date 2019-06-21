//
//  Pilot.swift
//  SpecPilot
//
//  Created by David Dubez on 19/06/2019.
//  Copyright © 2019 David Dubez. All rights reserved.
//

import Foundation

class Pilot {
    var name: String

    init(name: String) {
        self.name = name
    }

    var feedPump = Pump()
    var recyclPump = Pump()
    var scraper = GearMotor()

    var recirculationRate: Double {
        if recyclPump.dailyVolumeInL == 0 || feedPump.dailyVolumeInL == 0 {
            return 0
        } else {
            return (recyclPump.dailyVolumeInL / feedPump.dailyVolumeInL) * 100
        }
    }
}
// TODO:    - tests à faire
//          - Modifier pour sauvegarder les données dans core data,
//          - afficiher une liste des reglages à charger et charger le dernier reglages au lancment

// UPGRADE:     -  sauvegarder reglage su cloud
//              - exportx reglages en pdf
