//
//  Pump.swift
//  SpecPilot
//
//  Created by David Dubez on 19/06/2019.
//  Copyright © 2019 David Dubez. All rights reserved.
//

import Foundation

struct Pump {
    var cycleTimeInS: Double = 0
    var onTimeInS: Double = 0
    var flowRateInLH: Double = 1.5

    var dailyTotalTimeInH: Double {
        if cycleTimeInS == 0 || onTimeInS == 0 {
            return 0
        } else {
               return ((((60 * 60 * 24) / cycleTimeInS) * onTimeInS ) / 3600 ).rounded()
        }
    }

    var dailyVolumeInL: Double {
        return (dailyTotalTimeInH * flowRateInLH).rounded()
    }
}
