import Foundation

enum Secrets {
    static var supabaseURL: URL {
        guard let s = Bundle.main.object(forInfoDictionaryKey: "SUPABASE_URL") as? String,
              let url = URL(string: s) else {
            fatalError("❌ SUPABASE_URL missing in Secrets.plist")
        }
        return url
    }

    static var supabaseAnonKey: String {
        guard let s = Bundle.main.object(forInfoDictionaryKey: "SUPABASE_ANON_KEY") as? String else {
            fatalError("❌ SUPABASE_ANON_KEY missing in Secrets.plist")
        }
        return s
    }
}
