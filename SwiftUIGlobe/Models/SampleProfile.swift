import Foundation
import GlobeKit

public struct SampleProfile: GlobePointItem, Identifiable, Equatable {
    public let id: String
    public let name: String
    public let role: String
    public let city: String
    public let countryFlag: String
    public let avatarUrl: String
    public let rating: Double
    public let reactions: [String]

    public init(
        id: String,
        name: String,
        role: String,
        city: String,
        countryFlag: String,
        avatarUrl: String,
        rating: Double = 4.9,
        reactions: [String] = ["🔥", "⚡️", "✨", "❤️"]
    ) {
        self.id = id
        self.name = name
        self.role = role
        self.city = city
        self.countryFlag = countryFlag
        self.avatarUrl = avatarUrl
        self.rating = rating
        self.reactions = reactions
    }

    public static let sampleProfiles: [SampleProfile] = [
        SampleProfile(
            id: "1",
            name: "Sophia Chen",
            role: "AI Engineer",
            city: "Tokyo",
            countryFlag: "🇯🇵",
            avatarUrl: "https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=300&auto=format&fit=crop&q=80"
        ),
        SampleProfile(
            id: "2",
            name: "Liam Miller",
            role: "Product Designer",
            city: "London",
            countryFlag: "🇬🇧",
            avatarUrl: "https://images.unsplash.com/photo-1539571696357-5a69c17a67c6?w=300&auto=format&fit=crop&q=80"
        ),
        SampleProfile(
            id: "3",
            name: "Amara Diop",
            role: "Mobile Dev",
            city: "Dakar",
            countryFlag: "🇸🇳",
            avatarUrl: "https://images.unsplash.com/photo-1517841905240-472988babdf9?w=300&auto=format&fit=crop&q=80"
        ),
        SampleProfile(
            id: "4",
            name: "Lucas Silva",
            role: "Architect",
            city: "Rio de Janeiro",
            countryFlag: "🇧🇷",
            avatarUrl: "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=300&auto=format&fit=crop&q=80"
        ),
        SampleProfile(
            id: "5",
            name: "Emma Wilson",
            role: "Founder",
            city: "San Francisco",
            countryFlag: "🇺🇸",
            avatarUrl: "https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=300&auto=format&fit=crop&q=80"
        ),
        SampleProfile(
            id: "6",
            name: "Noah Schmidt",
            role: "Sound Engineer",
            city: "Berlin",
            countryFlag: "🇩🇪",
            avatarUrl: "https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=300&auto=format&fit=crop&q=80"
        ),
        SampleProfile(
            id: "7",
            name: "Amina Al-Mansoor",
            role: "Creative Lead",
            city: "Dubai",
            countryFlag: "🇦🇪",
            avatarUrl: "https://images.unsplash.com/photo-1524504388940-b1c1722653e1?w=300&auto=format&fit=crop&q=80"
        ),
        SampleProfile(
            id: "8",
            name: "Mateo Rossi",
            role: "Game Developer",
            city: "Milan",
            countryFlag: "🇮🇹",
            avatarUrl: "https://images.unsplash.com/photo-1522075469751-3a6694fb2f61?w=300&auto=format&fit=crop&q=80"
        ),
        SampleProfile(
            id: "9",
            name: "Chloe Dubois",
            role: "3D Artist",
            city: "Paris",
            countryFlag: "🇫🇷",
            avatarUrl: "https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=300&auto=format&fit=crop&q=80"
        ),
        SampleProfile(
            id: "10",
            name: "Oliver Taylor",
            role: "Fullstack Dev",
            city: "Sydney",
            countryFlag: "🇦🇺",
            avatarUrl: "https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?w=300&auto=format&fit=crop&q=80"
        ),
        SampleProfile(
            id: "11",
            name: "Zara Patel",
            role: "Data Scientist",
            city: "Mumbai",
            countryFlag: "🇮🇳",
            avatarUrl: "https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?w=300&auto=format&fit=crop&q=80"
        ),
        SampleProfile(
            id: "12",
            name: "Kenji Takahashi",
            role: "XR Engineer",
            city: "Kyoto",
            countryFlag: "🇯🇵",
            avatarUrl: "https://images.unsplash.com/photo-1519085360753-af0119f7cbe7?w=300&auto=format&fit=crop&q=80"
        )
    ]
}
