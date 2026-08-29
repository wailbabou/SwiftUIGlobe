import SwiftUI
import GlobeKit

public struct GlobeShowcaseView: View {
    @State private var profiles: [SampleProfile] = SampleProfile.sampleProfiles
    @State private var selectedProfile: SampleProfile? = nil
    @State private var isAutoRotate: Bool = true

    public init() {}

    private var globeConfig: GlobeConfig {
        GlobeConfig(
            autoRotationDuration: 22.0,
            isAutoRotationEnabled: isAutoRotate,
            selectedZoomScale: 1.5,
            unselectedBlurRadius: 7.0
        )
    }

    public var body: some View {
        ZStack {
            // Clean Light Background
            Color(red: 0.97, green: 0.98, blue: 0.99)
                .ignoresSafeArea()

            VStack(spacing: 16) {
                // Header
                HStack(alignment: .center) {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("SwiftUI Globe")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(Color(red: 0.06, green: 0.09, blue: 0.16))
                        Text("Interactive 3D Library Sample")
                            .font(.system(size: 13, weight: .medium))
                            .foregroundColor(Color(red: 0.39, green: 0.45, blue: 0.55))
                    }

                    Spacer()

                    // Status Pill
                    Text("\(profiles.count) Nodes")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(Color(red: 0.06, green: 0.09, blue: 0.16))
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(
                            Capsule()
                                .fill(Color.white)
                        )
                        .overlay(
                            Capsule()
                                .stroke(Color(red: 0.89, green: 0.91, blue: 0.94), lineWidth: 1)
                        )
                        .shadow(color: Color.black.opacity(0.04), radius: 2)
                }
                .padding(.horizontal, 20)
                .padding(.top, 8)

                // Control Toolbar
                HStack(spacing: 12) {
                    // Auto-spin toggle
                    Button {
                        withAnimation {
                            isAutoRotate.toggle()
                        }
                    } label: {
                        Image(systemName: isAutoRotate ? "pause.fill" : "play.fill")
                            .font(.system(size: 13, weight: .bold))
                            .foregroundColor(Color(red: 0.06, green: 0.09, blue: 0.16))
                            .frame(width: 38, height: 38)
                            .background(Circle().fill(Color.white))
                            .overlay(Circle().stroke(Color(red: 0.89, green: 0.91, blue: 0.94), lineWidth: 1))
                            .shadow(color: Color.black.opacity(0.04), radius: 2)
                    }

                    // Reset selection
                    Button {
                        withAnimation {
                            selectedProfile = nil
                        }
                    } label: {
                        Image(systemName: "arrow.counterclockwise")
                            .font(.system(size: 13, weight: .bold))
                            .foregroundColor(selectedProfile != nil ? Color(red: 0.06, green: 0.09, blue: 0.16) : Color(red: 0.65, green: 0.70, blue: 0.78))
                            .frame(width: 38, height: 38)
                            .background(Circle().fill(selectedProfile != nil ? Color.white : Color(red: 0.95, green: 0.96, blue: 0.98)))
                            .overlay(Circle().stroke(selectedProfile != nil ? Color(red: 0.89, green: 0.91, blue: 0.94) : Color.clear, lineWidth: 1))
                            .shadow(color: Color.black.opacity(selectedProfile != nil ? 0.04 : 0.0), radius: 2)
                    }
                    .disabled(selectedProfile == nil)
                }

                // 3D Globe Component
                Spacer(minLength: 0)

                GlobeView(
                    items: profiles,
                    selectedItem: $selectedProfile,
                    config: globeConfig,
                    wireframeColor: Color.black.opacity(0.08),
                    centerGlowColor: Color.black.opacity(0.03)
                ) { profile, isSelected, _ in
                    SampleGlobeItemView(profile: profile, isSelected: isSelected)
                }
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 8)

                Spacer(minLength: 0)

                // Bottom Selected Card - Clean White card with crisp Black text
                if let user = selectedProfile {
                    VStack {
                        HStack(spacing: 14) {
                            AsyncImage(url: URL(string: user.avatarUrl)) { phase in
                                if let img = phase.image {
                                    img.resizable().scaledToFill()
                                } else {
                                    Circle().fill(Color(red: 0.89, green: 0.91, blue: 0.94))
                                }
                            }
                            .frame(width: 52, height: 52)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color(red: 0.89, green: 0.91, blue: 0.94), lineWidth: 1.5))

                            VStack(alignment: .leading, spacing: 3) {
                                HStack(spacing: 6) {
                                    Text(user.name)
                                        .font(.system(size: 16, weight: .bold))
                                        .foregroundColor(Color(red: 0.06, green: 0.09, blue: 0.16))
                                    Text(user.countryFlag)
                                        .font(.system(size: 14))
                                }

                                Text("\(user.role) • \(user.city)")
                                    .font(.system(size: 12, weight: .medium))
                                    .foregroundColor(Color(red: 0.39, green: 0.45, blue: 0.55))

                                HStack(spacing: 3) {
                                    Image(systemName: "star.fill")
                                        .font(.system(size: 10))
                                        .foregroundColor(Color(red: 0.92, green: 0.70, blue: 0.03))
                                    Text("\(String(format: "%.1f", user.rating)) rating")
                                        .font(.system(size: 11))
                                        .foregroundColor(Color(red: 0.39, green: 0.45, blue: 0.55))
                                }
                            }

                            Spacer()

                            Button {
                                // Action demo
                            } label: {
                                Text("Connect")
                                    .font(.system(size: 12, weight: .bold))
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 14)
                                    .padding(.vertical, 8)
                                    .background(
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(Color(red: 0.06, green: 0.09, blue: 0.16))
                                    )
                            }
                        }
                    }
                    .padding(16)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.white)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color(red: 0.89, green: 0.91, blue: 0.94), lineWidth: 1)
                    )
                    .shadow(color: Color.black.opacity(0.06), radius: 8, y: 4)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                } else {
                    Text("Drag to rotate • Tap node to center")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(Color(red: 0.39, green: 0.45, blue: 0.55))
                        .padding(.horizontal, 14)
                        .padding(.vertical, 8)
                        .background(
                            Capsule()
                                .fill(Color.white)
                        )
                        .overlay(
                            Capsule()
                                .stroke(Color(red: 0.89, green: 0.91, blue: 0.94), lineWidth: 1)
                        )
                        .shadow(color: Color.black.opacity(0.04), radius: 2)
                        .padding(.bottom, 24)
                }
            }
        }
    }
}

#Preview {
    GlobeShowcaseView()
}
