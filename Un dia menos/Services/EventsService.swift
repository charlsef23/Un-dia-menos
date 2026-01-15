import Foundation
import Supabase

enum EventsService {
    static func fetchEvents() async throws -> [UDMEvent] {
        try await SupabaseManager.client
            .from("events")
            .select()
            .order("target_at", ascending: true)
            .execute()
            .value
    }

    static func createEvent(userId: UUID, title: String, subtitle: String?, targetAt: Date, color: String) async throws -> UDMEvent {
        struct Insert: Encodable {
            let user_id: UUID
            let title: String
            let subtitle: String?
            let target_at: Date
            let color: String
        }
        let inserted: [UDMEvent] = try await SupabaseManager.client
            .from("events")
            .insert(Insert(user_id: userId, title: title, subtitle: subtitle, target_at: targetAt, color: color))
            .select()
            .execute()
            .value
        guard let first = inserted.first else { throw NSError(domain: "Insert", code: -1) }
        return first
    }

    static func updateEvent(event: UDMEvent) async throws {
        struct Patch: Encodable {
            let title: String
            let subtitle: String?
            let target_at: Date
            let color: String
        }
        _ = try await SupabaseManager.client
            .from("events")
            .update(Patch(title: event.title, subtitle: event.subtitle, target_at: event.target_at, color: event.color))
            .eq("id", value: event.id.uuidString)
            .execute()
    }

    static func deleteEvent(eventId: UUID) async throws {
        _ = try await SupabaseManager.client
            .from("events")
            .delete()
            .eq("id", value: eventId.uuidString)
            .execute()
    }
}
