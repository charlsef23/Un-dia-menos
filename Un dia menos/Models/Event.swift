import Foundation

struct UDMEvent: Identifiable, Codable, Equatable {
    let id: UUID
    let user_id: UUID
    var title: String
    var subtitle: String?
    var target_at: Date
    var color: String
    let created_at: Date
    let updated_at: Date
}
