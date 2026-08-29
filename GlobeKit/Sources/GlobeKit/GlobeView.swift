import SwiftUI

public struct GlobeView<Item: GlobePointItem, ItemView: View>: View {
    public let items: [Item]
    @Binding public var selectedItem: Item?
    public var config: GlobeConfig
    public var showWireframe: Bool
    public var wireframeColor: Color
    public var centerGlowColor: Color
    public let itemContent: (Item, Bool, Double) -> ItemView

    // Rotation state
    @State private var baseRotX: Double = 0.0
    @State private var baseRotY: Double = 0.0
    @State private var baseDate: Date = Date()

    // Drag tracking
    @State private var isDragging: Bool = false
    @State private var dragStartRotX: Double = 0.0
    @State private var dragStartRotY: Double = 0.0

    // Centering animation tracking
    @State private var centeringAnimation: CenteringAnimationState? = nil

    private struct CenteringAnimationState {
        let startX: Double
        let startY: Double
        let targetX: Double
        let targetY: Double
        let startTime: Date
        let duration: Double
    }

    public init(
        items: [Item],
        selectedItem: Binding<Item?> = .constant(nil),
        config: GlobeConfig = .default,
        showWireframe: Bool = true,
        wireframeColor: Color = Color.white.opacity(0.15),
        centerGlowColor: Color = Color.white.opacity(0.06),
        @ViewBuilder itemContent: @escaping (Item, Bool, Double) -> ItemView
    ) {
        self.items = items
        self._selectedItem = selectedItem
        self.config = config
        self.showWireframe = showWireframe
        self.wireframeColor = wireframeColor
        self.centerGlowColor = centerGlowColor
        self.itemContent = itemContent
    }

    private var unitPoints: [(x: Double, y: Double, z: Double)] {
        GlobeMath.calculateFibonacciPoints(count: items.count)
    }

    public var body: some View {
        GeometryReader { proxy in
            let diameter = min(proxy.size.width, proxy.size.height)
            let radius = max(0, (diameter - config.padding * 2) / 2)

            TimelineView(.animation) { timeline in
                let now = timeline.date
                let (currentRotX, currentRotY) = calculateCurrentRotation(now: now)

                ZStack {
                    // Background Ambient Glow & Sphere Ring
                    if showWireframe {
                        Circle()
                            .fill(
                                RadialGradient(
                                    colors: [centerGlowColor, Color.clear],
                                    center: .center,
                                    startRadius: 0,
                                    endRadius: radius * 1.15
                                )
                            )
                            .frame(width: radius * 2.3, height: radius * 2.3)

                        Circle()
                            .stroke(wireframeColor, lineWidth: 1.2)
                            .frame(width: radius * 2, height: radius * 2)
                    }

                    // 3D Nodes
                    ForEach(Array(items.enumerated()), id: \.element.id) { index, item in
                        if index < unitPoints.count {
                            let pt = unitPoints[index]
                            let projected = GlobeMath.projectPoint(
                                x0: pt.x,
                                y0: pt.y,
                                z0: pt.z,
                                rotXDeg: currentRotX,
                                rotYDeg: currentRotY,
                                radius: radius
                            )

                            let isSelected = selectedItem?.id == item.id
                            let zoomScale = isSelected ? config.selectedZoomScale : 1.0
                            let blurRadius = (selectedItem != nil && !isSelected) ? config.unselectedBlurRadius : 0.0
                            let depthAlpha = isSelected ? 1.0 : min(max(projected.normalizedZ * 1.25, config.minDepthAlpha), 1.0)

                            itemContent(item, isSelected, projected.normalizedZ)
                                .scaleEffect(CGFloat(projected.scale) * zoomScale)
                                .blur(radius: blurRadius)
                                .opacity(depthAlpha)
                                .offset(x: CGFloat(projected.screenX), y: CGFloat(projected.screenY))
                                .zIndex(isSelected ? 1000 : projected.screenZ)
                                .animation(.easeInOut(duration: 0.4), value: isSelected)
                                .animation(.easeInOut(duration: 0.4), value: blurRadius)
                                .onTapGesture {
                                    handleItemTap(item: item, point: pt, currentRotX: currentRotX, currentRotY: currentRotY)
                                }
                        }
                    }
                }
                .frame(width: diameter, height: diameter)
                .contentShape(Rectangle())
                .onTapGesture {
                    if selectedItem != nil {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            selectedItem = nil
                            baseDate = Date()
                        }
                    }
                }
                .gesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { value in
                            if selectedItem != nil { return }
                            if !isDragging {
                                isDragging = true
                                dragStartRotX = currentRotX
                                dragStartRotY = currentRotY
                                centeringAnimation = nil
                            }
                            baseRotX = dragStartRotX - Double(value.translation.height) * config.dragSensitivity
                            baseRotY = dragStartRotY + Double(value.translation.width) * config.dragSensitivity
                            baseDate = now
                        }
                        .onEnded { _ in
                            isDragging = false
                            baseDate = now
                        }
                )
            }
        }
        .aspectRatio(1.0, contentMode: .fit)
    }

    private func calculateCurrentRotation(now: Date) -> (rotX: Double, rotY: Double) {
        if isDragging {
            return (baseRotX, baseRotY)
        }

        if let anim = centeringAnimation {
            let elapsed = now.timeIntervalSince(anim.startTime)
            let progress = min(1.0, max(0.0, elapsed / anim.duration))
            let ease = GlobeMath.easeInOutCubic(progress)

            let rotX = anim.startX + (anim.targetX - anim.startX) * ease
            let rotY = anim.startY + (anim.targetY - anim.startY) * ease

            if progress >= 1.0 {
                Task { @MainActor in
                    self.baseRotX = anim.targetX
                    self.baseRotY = anim.targetY
                    self.centeringAnimation = nil
                }
            }
            return (rotX, rotY)
        }

        if selectedItem != nil {
            return (baseRotX, baseRotY)
        }

        if config.isAutoRotationEnabled && config.autoRotationDuration > 0 {
            let elapsed = now.timeIntervalSince(baseDate)
            let autoRotY = elapsed * (360.0 / config.autoRotationDuration)
            return (baseRotX, baseRotY + autoRotY)
        }

        return (baseRotX, baseRotY)
    }

    private func handleItemTap(
        item: Item,
        point: (x: Double, y: Double, z: Double),
        currentRotX: Double,
        currentRotY: Double
    ) {
        if selectedItem?.id == item.id {
            selectedItem = nil
            baseDate = Date()
        } else {
            selectedItem = item
            let (targetX, targetY) = GlobeMath.calculateCenterAngles(
                point: point,
                currentRotX: currentRotX,
                currentRotY: currentRotY
            )
            centeringAnimation = CenteringAnimationState(
                startX: currentRotX,
                startY: currentRotY,
                targetX: targetX,
                targetY: targetY,
                startTime: Date(),
                duration: config.centeringDuration
            )
        }
    }
}
