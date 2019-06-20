//
//  DesignCalculation.swift
//  SpecPilot
//
//  Created by David Dubez on 11/06/2019.
//  Copyright © 2019 David Dubez. All rights reserved.
//

import Foundation

class DesignCalculation {
    // MARK: - Properties
    var massLoadInKg: Double = 0
    var effluentsDcoInmgl: Double = 0
    var effluentsDcoDbo: Double = 0
    var effluentsVolumeInL: Double = 0
    var effluentsDboInMgl: Double = 0
    var mudSMInGl: Double = 0
    var mudMVSInPercent: Double = 0
    var mudVolumeInL: Double = 0
    var reactorMass: Double = 0
    var mudDcoInMgl: Double = 0

    // MARK: - Methods
    func calculate() {
        reactorMass = mudSMInGl * mudMVSInPercent * mudVolumeInL
        effluentsDboInMgl = effluentsDcoInmgl / effluentsDcoDbo
        effluentsVolumeInL = (massLoadInKg * reactorMass * 1000) / effluentsDboInMgl
    }
}
