import SwiftUI

struct EventDetailView: View {
    @EnvironmentObject var auth: AuthService
    @Environment(\.dismiss) private var dismiss

    @State var event: UDMEvent
    @State private var unit: CountdownUnit = .days
    @State private var media: [UDMEventMedia] = []
    @State private var isLoadingMedia = false
    @State private var showEdit = false
    @State private var error: String? = nil

    var body: some View {
        let tint = Brand.accent(hex: event.color)

        ScrollView {
            VStack(spacing: 14) {
                GlassCard {
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            VStack(alignment: .leading, spacing: 6) {
                                Text(event.title)
                                    .font(.system(size: 26, weight: .semibold, design: .rounded))
                                if let s = event.subtitle, !s.isEmpty {
                                    Text(s).foregroundStyle(.secondary)
                                }
                            }
                            Spacer()
                            Circle().fill(tint).frame(width: 14, height: 14)
                        }

                        CountdownView(target: event.target_at, unit: unit, tint: tint)

                        Picker("Unidad", selection: $unit) {
                            ForEach(CountdownUnit.allCases, id: \.self) { u in
                                Text(u.label).tag(u)
                            }
                        }
                        .pickerStyle(.segmented)
                    }
                }

                MediaGridView(
                    event: event,
                    media: $media,
                    isLoading: $isLoadingMedia,
                    onError: { error = $0 }
                )
            }
            .padding(18)
        }
        .navigationTitle("Evento")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Menu {
                    Button("Editar", systemImage: "pencil") { showEdit = true }
                    Button("Borrar", systemImage: "trash", role: .destructive) {
                        Task { await deleteEvent() }
                    }
                } label: {
                    Image(systemName: "ellipsis.circle")
                }
            }
        }
        .sheet(isPresented: $showEdit) {
            NavigationStack {
                EventEditorView(mode: .edit(event)) { updated in
                    event = updated
                    showEdit = false
                }
            }
        }
        .task { await loadMedia() }
        .alert("Error", isPresented: .constant(error != nil)) {
            Button("OK") { error = nil }
        } message: {
            Text(error ?? "")
        }
    }

    private func loadMedia() async {
        isLoadingMedia = true
        defer { isLoadingMedia = false }
        do {
            media = try await MediaService.fetchMedia(eventId: event.id)
        } catch {
            self.error = error.localizedDescription
        }
    }

    private func deleteEvent() async {
        do {
            try await EventsService.deleteEvent(eventId: event.id)
            dismiss()
        } catch {
            self.error = error.localizedDescription
        }
    }
}
