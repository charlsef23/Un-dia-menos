import Foundation
import Supabase

enum SupabaseManager {
    static let client = SupabaseClient(
        supabaseURL: Secrets.supabaseURL,
        supabaseKey: Secrets.supabaseAnonKey
    )
}
