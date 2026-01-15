import Foundation
import Supabase

enum MediaService {
    static let bucket = "event-media"

    static func fetchMedia(eventId: UUID) async throws -> [UDMEventMedia] {
        try await SupabaseManager.client
            .from("event_media")
            .select()
            .eq("event_id", value: eventId.uuidString)
            .order("created_at", ascending: false)
            .execute()
            .value
    }

    static func addMediaRow(
        eventId: UUID,
        userId: UUID,
        kind: String,
        path: String
    ) async throws -> UDMEventMedia {
        struct Insert: Encodable {
            let event_id: UUID
            let user_id: UUID
            let kind: String
            let storage_path: String
        }

        let inserted: [UDMEventMedia] = try await SupabaseManager.client
            .from("event_media")
            .insert(Insert(event_id: eventId, user_id: userId, kind: kind, storage_path: path))
            .select()
            .execute()
            .value

        guard let first = inserted.first else {
            throw NSError(domain: "InsertMedia", code: -1, userInfo: [NSLocalizedDescriptionKey: "No row returned"])
        }
        return first
    }

    static func deleteMediaRow(mediaId: UUID) async throws {
        _ = try await SupabaseManager.client
            .from("event_media")
            .delete()
            .eq("id", value: mediaId.uuidString)
            .execute()
    }

    // ✅ FIX: new Supabase SDK signature
    // renamed from upload(path:file:options:) -> upload(_:data:options:)
    static func upload(data: Data, contentType: String, path: String) async throws {
        _ = try await SupabaseManager.client.storage
            .from(bucket)
            .upload(
                path,
                data: data,
                options: FileOptions(contentType: contentType, upsert: false)
            )
    }

    static func signedURL(path: String, expiresIn: Int = 60 * 30) async throws -> URL {
        try await SupabaseManager.client.storage
            .from(bucket)
            .createSignedURL(path: path, expiresIn: expiresIn)
    }

    static func removeFromStorage(path: String) async throws {
        _ = try await SupabaseManager.client.storage
            .from(bucket)
            .remove(paths: [path])
    }
}
