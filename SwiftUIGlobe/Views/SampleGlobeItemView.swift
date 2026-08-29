import SwiftUI

public struct SampleGlobeItemView: View {
    public let profile: SampleProfile
    public let isSelected: Bool

    public init(profile: SampleProfile, isSelected: Bool) {
        self.profile = profile
        self.isSelected = isSelected
    }

    public var body: some View {
        ZStack(alignment: .center) {
            // Main Avatar Circle
            ZStack {
                AsyncImage(url: URL(string: profile.avatarUrl)) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                    case .empty, .failure:
                        Circle()
                            .fill(Color(red: 0.89, green: 0.91, blue: 0.94))
                            .overlay(
                                Image(systemName: "person.fill")
                                    .foregroundColor(Color(red: 0.39, green: 0.45, blue: 0.55))
                            )
                    @unknown default:
                        EmptyView()
                    }
                }
                .frame(width: isSelected ? 84 : 60, height: isSelected ? 84 : 60)
                .clipShape(Circle())
                .overlay(
                    Circle()
                        .stroke(
                            isSelected ? Color(red: 0.06, green: 0.09, blue: 0.16) : Color.white,
                            lineWidth: isSelected ? 3 : 1.5
                        )
                )
                .shadow(color: Color.black.opacity(isSelected ? 0.18 : 0.08), radius: isSelected ? 8 : 4)
            }

            // Country Flag Badge (Top Left)
            Text(profile.countryFlag)
                .font(.system(size: isSelected ? 14 : 11))
                .padding(3)
                .background(Circle().fill(Color.white))
                .overlay(Circle().stroke(Color(red: 0.89, green: 0.91, blue: 0.94), lineWidth: 1))
                .shadow(color: Color.black.opacity(0.06), radius: 2)
                .offset(x: isSelected ? -34 : -24, y: isSelected ? -34 : -24)

            // City Tag (Top Right)
            Text(profile.city)
                .font(.system(size: isSelected ? 11 : 9, weight: .bold))
                .foregroundColor(isSelected ? .white : Color(red: 0.06, green: 0.09, blue: 0.16))
                .padding(.horizontal, 6)
                .padding(.vertical, 2)
                .background(
                    Capsule()
                        .fill(isSelected ? Color(red: 0.06, green: 0.09, blue: 0.16) : Color.white)
                )
                .overlay(
                    Capsule()
                        .stroke(isSelected ? Color(red: 0.06, green: 0.09, blue: 0.16) : Color(red: 0.89, green: 0.91, blue: 0.94), lineWidth: 1)
                )
                .shadow(color: Color.black.opacity(0.06), radius: 2)
                .offset(x: isSelected ? 34 : 24, y: isSelected ? -34 : -24)

            // Selected Name Capsule (Bottom) - Clean dark capsule with bold white text
            if isSelected {
                Text(profile.name)
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(
                        Capsule()
                            .fill(Color(red: 0.06, green: 0.09, blue: 0.16))
                    )
                    .shadow(color: Color.black.opacity(0.12), radius: 4)
                    .offset(y: 48)
                    .transition(.opacity.combined(with: .scale))
            }
        }
        .frame(width: isSelected ? 130 : 84, height: isSelected ? 130 : 84)
    }
}
