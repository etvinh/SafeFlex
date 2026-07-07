import Foundation
import Supabase

enum SupabaseConfig {
    /// Local dev stack (`supabase start`). For a hosted project, replace
    /// with your project URL and anon key from the Supabase dashboard.
    /// Running on a physical iPhone against the local stack? Use your
    /// Mac's LAN IP instead of 127.0.0.1.
    ///
    /// The anon key is publishable by design — row-level security in
    /// supabase/migrations is the boundary that keeps users' data apart.
    static let url = URL(string: "http://127.0.0.1:54321")!
    static let anonKey = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZS1kZW1vIiwicm9sZSI6ImFub24iLCJleHAiOjE5ODM4MTI5OTZ9.CRXP1A7WOeoJeXxjNni43kdQwgnWNReilDMblYTn_I0"
}

extension SupabaseClient {
    /// The one configured client for the whole app. Only files in Data/
    /// may import Supabase or touch this.
    static let shared = SupabaseClient(
        supabaseURL: SupabaseConfig.url,
        supabaseKey: SupabaseConfig.anonKey
    )
}
