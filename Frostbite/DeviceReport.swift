
import Foundation
import UIKit
import Darwin

struct DeviceReport {
    let machineIdentifier: String
    let systemVersion: String
    let buildVersion: String

    // Reference values only. These are not detected hardware properties.
    private static let targetMachineIdentifier = "iPhone18,5"
    private static let targetSystemVersion = "27.3"
    private static let targetBuildVersion = "24C5037i"

    static var current: DeviceReport {
        func sysctlString(_ name: String) -> String {
            var size = 0

            guard sysctlbyname(name, nil, &size, nil, 0) == 0,
                  size > 0 else {
                return "Unavailable"
            }

            var buffer = [CChar](repeating: 0, count: size)

            guard sysctlbyname(name, &buffer, &size, nil, 0) == 0 else {
                return "Unavailable"
            }

            return String(cString: buffer)
        }

        return DeviceReport(
            machineIdentifier: sysctlString("hw.machine"),
            systemVersion: UIDevice.current.systemVersion,
            buildVersion: sysctlString("kern.osversion")
        )
    }

    // nil means at least one required value could not be read.
    var matchesResearchTarget: Bool? {
        guard machineIdentifier != "Unavailable",
              buildVersion != "Unavailable",
              !systemVersion.isEmpty else {
            return nil
        }

        return machineIdentifier == Self.targetMachineIdentifier
            && systemVersion == Self.targetSystemVersion
            && buildVersion == Self.targetBuildVersion
    }

    var researchTargetStatus: String {
        switch matchesResearchTarget {
        case .some(true):
            return "Exact match"

        case .some(false):
            return "Different device/build"

        case .none:
            return "Unable to verify"
        }
    }
}
