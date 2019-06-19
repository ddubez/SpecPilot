//
//  PilotSetting.swift
//  SpecPilot
//
//  Created by David Dubez on 19/06/2019.
//  Copyright © 2019 David Dubez. All rights reserved.
//

import Foundation

class PilotSetting {
    // Class for store settings of the pilot

    static let shared = PilotSetting()
    private init() {}

    var feedPumpFlowRate: Double = 0.0
    var recyclPumpFlowRate: Double = 0.0

}
