import Foundation

public struct ProjectedGlobePoint: Sendable {
    public let screenX: Double
    public let screenY: Double
    public let screenZ: Double
    public let normalizedZ: Double
    public let scale: Double

    public init(
        screenX: Double,
        screenY: Double,
        screenZ: Double,
        normalizedZ: Double,
        scale: Double
    ) {
        self.screenX = screenX
        self.screenY = screenY
        self.screenZ = screenZ
        self.normalizedZ = normalizedZ
        self.scale = scale
    }
}

public enum GlobeMath {

    /// Generate uniformly distributed 3D spherical coordinates using Fibonacci sphere algorithm
    public static func calculateFibonacciPoints(count: Int) -> [(x: Double, y: Double, z: Double)] {
        guard count > 0 else { return [] }
        let goldenRatio = (1.0 + sqrt(5.0))
        return (0..<count).map { i in
            let phi = acos(1.0 - 2.0 * (Double(i) + 0.5) / Double(count))
            let theta = Double.pi * goldenRatio * Double(i)
            return (
                x: sin(phi) * cos(theta),
                y: cos(phi),
                z: sin(phi) * sin(theta)
            )
        }
    }

    /// Project a 3D unit sphere point to 2D screen coordinates
    public static func projectPoint(
        x0: Double,
        y0: Double,
        z0: Double,
        rotXDeg: Double,
        rotYDeg: Double,
        radius: Double
    ) -> ProjectedGlobePoint {
        let radX = rotXDeg * .pi / 180.0
        let radY = rotYDeg * .pi / 180.0

        // Pitch rotation (X-axis)
        let y1 = y0 * cos(radX) - z0 * sin(radX)
        let z1 = y0 * sin(radX) + z0 * cos(radX)
        let x1 = x0

        // Yaw rotation (Y-axis)
        let x2 = x1 * cos(radY) + z1 * sin(radY)
        let z2 = -x1 * sin(radY) + z1 * cos(radY)
        let y2 = y1

        let screenX = x2 * radius
        let screenY = y2 * radius
        let screenZ = z2 * radius

        let normalizedZ = ((screenZ / radius) + 1.0) / 2.0
        let scale = 0.55 + 0.45 * normalizedZ

        return ProjectedGlobePoint(
            screenX: screenX,
            screenY: screenY,
            screenZ: screenZ,
            normalizedZ: min(max(normalizedZ, 0.0), 1.0),
            scale: scale
        )
    }

    /// Find the shortest path representation of angle `target` relative to `current`
    public static func normalizeAngle(current: Double, target: Double) -> Double {
        var diff = (target - current).truncatingRemainder(dividingBy: 360.0)
        if diff > 180.0 { diff -= 360.0 }
        if diff < -180.0 { diff += 360.0 }
        return current + diff
    }

    /// Calculate target rotation angles (pitch and yaw) to center a point to front view
    public static func calculateCenterAngles(
        point: (x: Double, y: Double, z: Double),
        currentRotX: Double,
        currentRotY: Double
    ) -> (targetRotX: Double, targetRotY: Double) {
        let rawTargetX = atan2(point.y, point.z) * 180.0 / .pi
        let targetRotX = normalizeAngle(current: currentRotX, target: rawTargetX)

        let radX = targetRotX * .pi / 180.0
        let z1 = point.y * sin(radX) + point.z * cos(radX)
        let rawTargetY = atan2(-point.x, z1) * 180.0 / .pi
        let targetRotY = normalizeAngle(current: currentRotY, target: rawTargetY)

        return (targetRotX, targetRotY)
    }

    public static func easeInOutCubic(_ t: Double) -> Double {
        t < 0.5 ? 4.0 * t * t * t : 1.0 - pow(-2.0 * t + 2.0, 3.0) / 2.0
    }
}
