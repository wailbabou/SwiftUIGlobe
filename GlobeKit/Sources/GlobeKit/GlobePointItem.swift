import Foundation

/// Protocol for items positioned on the 3D globe
public protocol GlobePointItem: Identifiable {
    var id: String { get }
}

/// Default lightweight implementation of `GlobePointItem`
public struct DefaultGlobeItem: GlobePointItem, Equatable {
    public let id: String
    public let title: String
    public let subtitle: String
    public let imageUrl: String?

    public init(
        id: String = UUID().uuidString,
        title: String = "",
        subtitle: String = "",
        imageUrl: String? = nil
    ) {
        self.id = id
        self.title = title
        self.subtitle = subtitle
        self.imageUrl = imageUrl
    }
}
