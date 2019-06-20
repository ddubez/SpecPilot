//
//  DesignCalculation.swift
//  SpecPilot
//
//  Created by David Dubez on 11/06/2019.
//  Copyright © 2019 David Dubez. All rights reserved.
//

import Foundation

struct DesignCalculation {
    // MARK: - Properties
    var massLoadInKg: Double?
    var effluentsDcoInmgl: Double?
    var effluentsDcoDbo: Double?
    var mudSMInGl: Double?
    var mudMVSInPercent: Double?
    var mudVolumeInL: Double?
    var mudDcoInMgl: Double?

    var reactorMass: Double? {
        guard let mudSMInGlValue = mudSMInGl else {
            return nil
        }
        guard let mudMVSInPercentValue = mudMVSInPercent else {
            return nil
        }
        guard let mudVolumeInLValue = mudVolumeInL else {
            return nil
        }
        return mudSMInGlValue * mudMVSInPercentValue * mudVolumeInLValue / 100
    }
    var effluentsDboInMgl: Double? {
        guard let effluentsDcoInmglValue = effluentsDcoInmgl else {
            return nil
        }
        guard let effluentsDcoDboValue = effluentsDcoDbo else {
            return nil
        }
        return effluentsDcoInmglValue / effluentsDcoDboValue
    }
    var effluentsVolumeInL: Double? {
        guard let massLoadInKgValue = massLoadInKg else {
            return nil
        }
        guard let reactorMassValue = reactorMass else {
            return nil
        }
        guard let effluentsDboInMglValue = effluentsDboInMgl else {
            return nil
        }
        return (massLoadInKgValue * reactorMassValue * 1000) / effluentsDboInMglValue
    }
}
// TODO: tests à faire
