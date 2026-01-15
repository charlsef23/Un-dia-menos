import Foundation

struct UDMEventMedia: Identifiable, Codable, Equatable {
    let id: UUID
    let event_id: UUID
    let user_id: UUID
    let kind: String // "image" | "video"
    let storage_path: String
    let thumb_path: String?
    let created_at: Date
}
