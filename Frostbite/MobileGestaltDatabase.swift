import Foundation

struct MobileGestaltKey: Identifiable, Hashable {
    let name: String
    let identifier: String
    let firstSeen: String
    let category: String
    let note: String

    var id: String { identifier }

    static let all: [MobileGestaltKey] = [
        .init(name: "DeviceSupportsDynamicIsland", identifier: "YlEtTtHlNesRBMal1CqRaA", firstSeen: "iOS 17.4+", category: "Display", note: "Mapped capability selector associated with Dynamic Island support."),
        .init(name: "DeviceSupportsAlwaysOnDisplay", identifier: "2OOJf1VhaM7NxfRok3HbWQ", firstSeen: "iOS 18.0+", category: "Display", note: "Mapped capability selector associated with Always-On Display."),
        .init(name: "DeviceSupportsHighLuminanceAlwaysOnDisplay", identifier: "7brdL5xrEUWnlF9C0kdg5A", firstSeen: "iOS 27.0+", category: "Display", note: "Mapped selector associated with high-luminance Always-On Display."),
        .init(name: "DeviceSupportsTouchSensitiveCameraControl", identifier: "lyJZrSDc8J8eQ5Zb7A1Rvw", firstSeen: "iOS 27.0+", category: "Camera", note: "Mapped selector related to touch-sensitive Camera Control."),
        .init(name: "DeviceSupports80ChargeLimit", identifier: "37NVydb//GP/GrhuTN+exg", firstSeen: "iOS 17.0+", category: "Power", note: "Mapped selector associated with the 80 percent charge limit feature."),
        .init(name: "DeviceSupportsBootChime", identifier: "QHxt+hGLaBPbQJbXiUJX3w", firstSeen: "iOS 16.0+", category: "Audio", note: "Mapped selector associated with the startup sound feature."),
        .init(name: "DeviceSupportsTapToWake", identifier: "yZf3GTRMGTuwSV/lD7Cagw", firstSeen: "iOS 11.0+", category: "Display", note: "Mapped selector associated with Tap to Wake."),
        .init(name: "UIParallaxCapability", identifier: "mmu76v66k1dAtghToInT8g", firstSeen: "iOS 7.0+", category: "Interface", note: "Mapped UI capability selector associated with parallax behavior."),
        .init(name: "DeviceSupportsLandscapeFaceID", identifier: "eP/CPXY0Q1CoIqAWn/J97g", firstSeen: "iOS 17.0+", category: "Security", note: "Mapped selector associated with landscape Face ID."),
        .init(name: "DeviceSupportsApplePencil", identifier: "yhHcB0iH0d1XzPO/CFd3ow", firstSeen: "iOS 9.3+", category: "Accessories", note: "Mapped selector associated with Apple Pencil support."),
        .init(name: "DeviceSupportsFindApplePencil", identifier: "nXbrTiBAf1dbo4sCn7xs2w", firstSeen: "iOS 17.5+", category: "Accessories", note: "Mapped selector associated with finding Apple Pencil."),
        .init(name: "DeviceSupportsSiriUnderstandingOnDevice", identifier: "K/R1GfGfCkXvEhaPS2Vrng", firstSeen: "iOS 17.0+", category: "Intelligence", note: "Mapped selector associated with on-device Siri understanding.")
    ]

    static let sourceURL = URL(string: "https://github.com/PoomSmart/MGKeys")!
}
