import Foundation

/// Single home for the sensor's unit conversions. The wearable reports
/// flex as 0–1000 (mapped onto a 0–180° range of motion) and stability
/// as 0–5 (mapped onto 0–100%, higher is steadier).
enum SensorScale {
    static let flexMax = 1000.0
    static let romFullRangeDegrees = 180.0
    static let stabilityMax = 5.0

    static func flexPercent(_ flex: Double) -> Int {
        Int(min(100, max(0, flex / flexMax * 100)))
    }

    static func romDegrees(fromFlex flex: Double) -> Double {
        min(romFullRangeDegrees, max(0, flex / flexMax * romFullRangeDegrees))
    }

    static func stabilityPercent(_ stability: Double) -> Double {
        min(100, max(0, stability / stabilityMax * 100))
    }
}
