# SwiftUIGlobe 🌍

[![Platform](https://img.shields.io/badge/Platform-iOS%2017%2B%20%7C%20macOS%2014%2B-blue.svg?style=flat&logo=apple)](https://developer.apple.com/swift/)
[![Swift](https://img.shields.io/badge/Swift-5.9%2B-orange.svg?style=flat&logo=swift)](https://swift.org)
[![SwiftUI](https://img.shields.io/badge/SwiftUI-Ready-F05138.svg?style=flat&logo=swift)](https://developer.apple.com/xcode/swiftui/)
[![SPM](https://img.shields.io/badge/Swift%20Package%20Manager-compatible-brightgreen.svg?style=flat)](https://swift.org/package-manager/)
[![License](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

An interactive, pure **SwiftUI 3D Globe component** built with `TimelineView` and vector projection math. Provides smooth 2-axis drag gestures, geodesic shortest-path centering animations, depth scaling, and dynamic unselected-node background blur effects.

---

## ✨ Features

- 📱 **Pure SwiftUI**: Zero third-party C/C++ or SceneKit/Metal overhead. Powered entirely by SwiftUI `TimelineView`, `DragGesture`, and standard 3D trigonometry.
- 📐 **Fibonacci Sphere Lattice**: Uniformly distributes any quantity of items across the sphere using the spherical golden ratio spiral.
- 🎯 **Shortest-Path Auto-Centering**: Tapping any node calculates the minimal angular offset across both axes and smoothly rotates the globe to bring the item front and center.
- 🔍 **Depth Perspective & Dynamic Blur**:
  - Front nodes are scaled up and fully opaque.
  - Distant nodes naturally fade with configurable minimum depth alpha.
  - Non-selected background nodes smoothly blur when an item is selected.
  - Correct Z-indexing ensures front & selected elements are always interactive.
- 🔄 **Continuous Auto-Rotation**: Nanosecond-precise rotation clock that pauses during drag gestures or item selection.
- 🧩 **Generic ViewBuilder Slot**: Decoupled from data models. Render avatars, user cards, reaction pills, flags, or glowing points.
- 📦 **Swift Package (`GlobeKit`)**: Ready to import as an SPM package or embed in your app.

---

## 🧠 How It Works

### 1. Fibonacci Sphere Lattice
Items are distributed uniformly across a unit sphere using the Fibonacci lattice:
$$\phi = \arccos\left(1 - \frac{2(i + 0.5)}{N}\right)$$
$$\theta = \pi \cdot (1 + \sqrt{5}) \cdot i$$
$$x = \sin\phi \cos\theta, \quad y = \cos\phi, \quad z = \sin\phi \sin\theta$$

### 2. 3D-to-2D Projection & Camera Angles
Given pitch rotation angle $\alpha$ and yaw rotation angle $\beta$:
1. **Pitch (X-Axis)**:
   $$y' = y \cos\alpha - z \sin\alpha, \quad z' = y \sin\alpha + z \cos\alpha$$
2. **Yaw (Y-Axis)**:
   $$x'' = x \cos\beta + z' \sin\beta, \quad z'' = -x \sin\beta + z' \cos\beta$$
3. **Screen Projection**:
   $$\text{screenX} = x'' \cdot R, \quad \text{screenY} = y' \cdot R, \quad \text{screenZ} = z'' \cdot R$$
   $$\text{scale} = 0.55 + 0.45 \cdot \text{normalizedZ}$$

### 3. Geodesic Centering
When centering on a selected node at $(x_0, y_0, z_0)$:
$$\text{targetRotX} = \text{atan2}(y_0, z_0) \cdot \frac{180^\circ}{\pi}$$
$$\text{targetRotY} = \text{atan2}(-x_0, z_1) \cdot \frac{180^\circ}{\pi}$$
Angles are normalized using minimal modulo differences ($[-180^\circ, +180^\circ]$) to ensure the shortest rotational path.

---

## 📦 Installation

### Swift Package Manager (SPM)

Add `GlobeKit` to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/wailbabou/SwiftUIGlobe.git", from: "0.1")
]
```

Or in Xcode:
1. File -> **Add Package Dependencies...**
2. Enter repository URL: `https://github.com/wailbabou/SwiftUIGlobe.git`
3. Add `GlobeKit` to your target.

---

## 🚀 Quickstart

### 1. Define your data model
Implement the `GlobePointItem` protocol:

```swift
import Foundation
import GlobeKit

struct UserProfile: GlobePointItem, Identifiable, Equatable {
    let id: String
    let name: String
    let avatarUrl: String
}
```

### 2. Render `GlobeView` in SwiftUI
```swift
import SwiftUI
import GlobeKit

struct ContentView: View {
    let users = [
        UserProfile(id: "1", name: "Sophia", avatarUrl: "https://..."),
        UserProfile(id: "2", name: "Liam", avatarUrl: "https://..."),
        UserProfile(id: "3", name: "Amara", avatarUrl: "https://...")
    ]

    @State private var selectedUser: UserProfile? = nil

    var body: some View {
        GlobeView(
            items: users,
            selectedItem: $selectedUser
        ) { user, isSelected, normalizedZ in
            // Custom View for each node
            AsyncImage(url: URL(string: user.avatarUrl)) { image in
                image.resizable().scaledToFill()
            } placeholder: {
                Circle().fill(Color.gray.opacity(0.3))
            }
            .frame(width: isSelected ? 80 : 56, height: isSelected ? 80 : 56)
            .clipShape(Circle())
            .overlay(
                Circle().stroke(isSelected ? Color.black : Color.white, lineWidth: isSelected ? 3 : 1.5)
            )
            .shadow(radius: isSelected ? 8 : 3)
        }
        .frame(maxWidth: .infinity)
        .padding()
    }
}
```

---

## 🛠️ Advanced Configuration

Customize rotation speeds, blur intensities, zoom factors, and sensitivity using `GlobeConfig`:

```swift
let customConfig = GlobeConfig(
    autoRotationDuration: 18.0,    // 18s per 360° spin
    isAutoRotationEnabled: true,   // Enable or disable auto-spin
    selectedZoomScale: 1.5,        // 150% zoom on selected item
    unselectedBlurRadius: 7.0,     // 7pt blur on unselected nodes
    minDepthAlpha: 0.15,           // Min opacity for background nodes
    dragSensitivity: 0.25,         // Drag gesture rotation responsiveness
    centeringDuration: 0.8,        // Centering ease-in-out duration
    padding: 40.0                  // Outer padding from view frame
)

GlobeView(
    items: profiles,
    selectedItem: $selectedProfile,
    config: customConfig,
    showWireframe: true,
    wireframeColor: Color.black.opacity(0.08),
    centerGlowColor: Color.black.opacity(0.03)
) { profile, isSelected, normalizedZ in
    SampleGlobeItemView(profile: profile, isSelected: isSelected)
}
```

---

## 📖 API Reference

### `GlobeView` Parameters

| Parameter | Type | Default | Description |
|---|---|---|---|
| `items` | `[Item: GlobePointItem]` | *Required* | Array of items to place on the 3D sphere. |
| `selectedItem` | `Binding<Item?>` | `.constant(nil)` | Two-way binding for the currently focused item. |
| `config` | `GlobeConfig` | `.default` | Configuration for physics, animations, and blur. |
| `showWireframe` | `Bool` | `true` | Whether to draw ambient sphere meridian/equator lines. |
| `wireframeColor` | `Color` | `Color.white.opacity(0.15)` | Stroke color for the sphere outline. |
| `centerGlowColor` | `Color` | `Color.white.opacity(0.06)` | Radial gradient color for the core sphere aura. |
| `itemContent` | `@ViewBuilder (Item, Bool, Double) -> Content` | *Required* | ViewBuilder slot to render each node's UI. |

---

## 🏛️ Project Architecture

```
SwiftUIGlobe/
├── GlobeKit/                       # 📦 Standalone Swift Package
│   ├── Package.swift
│   └── Sources/GlobeKit/
│       ├── GlobeView.swift         # Core 3D Globe SwiftUI View
│       ├── GlobeConfig.swift       # Configuration struct & parameters
│       ├── GlobeMath.swift         # Fibonacci & 3D projection algorithms
│       └── GlobePointItem.swift    # GlobePointItem protocol
└── SwiftUIGlobe/                   # 📱 Sample Showcase Application
    ├── SwiftUIGlobeApp.swift
    ├── ContentView.swift
    ├── Models/SampleProfile.swift
    └── Views/
        ├── GlobeShowcaseView.swift
        └── SampleGlobeItemView.swift
```

---

## 🙏 Credits

This library was inspired by the globe visualization concept from [**compose_concepts**](https://github.com/pedromassango/compose_concepts) by [@pedromassango](https://github.com/pedromassango). Big thanks for the creative foundation!

---

## 📄 License

```
MIT License

Copyright (c) 2026 Ouail Bellal

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.
```
