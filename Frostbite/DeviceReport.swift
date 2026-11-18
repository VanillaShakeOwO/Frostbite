import Foundation
import UIKit

struct DeviceReport {
    let machineIdentifier: String
    let systemVersion: String
    let buildVersion: String

    static var current: DeviceReport {
        func sysctlString(_ name: String) -> String {
            var size = 0
            guard sysctlbyname(name, nil, &size, nil, 0) == 0, size > 0 else {
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

    var matchesResearchTarget: Bool {
        machineIdentifier == "iPhone18,5"
            && systemVersion == "27.3"
            && buildVersion == "24C5037i"
    }
}
