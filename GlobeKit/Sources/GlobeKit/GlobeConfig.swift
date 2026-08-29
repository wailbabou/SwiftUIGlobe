import SwiftUI

/// Configuration settings for the GlobeView appearance and physics
public struct GlobeConfig: Sendable {
    public var autoRotationDuration: Double
    public var isAutoRotationEnabled: Bool
    public var selectedZoomScale: CGFloat
    public var unselectedBlurRadius: CGFloat
    public var minDepthAlpha: Double
    public var dragSensitivity: Double
    public var centeringDuration: Double
    public var padding: CGFloat

    public init(
        autoRotationDuration: Double = 22.0,
        isAutoRotationEnabled: Bool = true,
        selectedZoomScale: CGFloat = 1.45,
        unselectedBlurRadius: CGFloat = 6.0,
        minDepthAlpha: Double = 0.15,
        dragSensitivity: Double = 0.25,
        centeringDuration: Double = 0.8,
        padding: CGFloat = 48.0
    ) {
        self.autoRotationDuration = autoRotationDuration
        self.isAutoRotationEnabled = isAutoRotationEnabled
        self.selectedZoomScale = selectedZoomScale
        self.unselectedBlurRadius = unselectedBlurRadius
        self.minDepthAlpha = minDepthAlpha
        self.dragSensitivity = dragSensitivity
        self.centeringDuration = centeringDuration
        self.padding = padding
    }

    public static let `default` = GlobeConfig()
}
