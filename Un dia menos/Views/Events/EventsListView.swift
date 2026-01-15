import SwiftUI

struct EventsListView: View {
    @EnvironmentObject var auth: AuthService
    @State private var events: [UDMEvent] = []
    @State private var isLoading = false
    @State private var showCreate = false
    @State private var error: String? = nil

    var body: some View {
        NavigationStack {
            ZStack {
                Brand.bg.ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 14) {
                        header

                        if isLoading {
                            ProgressView().padding(.top, 30)
                        } else if events.isEmpty {
                            emptyState
                        } else {
                            ForEach(events) { event in
                                NavigationLink {
                                    EventDetailView(event: event)
                                } label: {
                                    EventRow(event: event)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }
                    .padding(18)
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showCreate = true
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .font(.title3)
                    }
                }
            }
            .sheet(isPresented: $showCreate) {
                NavigationStack {
                    EventEditorView(mode: .create) { created in
                        events.insert(created, at: 0)
                        events.sort { $0.target_at < $1.target_at }
                        showCreate = false
                    }
                }
            }
            .task { await reload() }
            .refreshable { await reload() }
            .alert("Error", isPresented: .constant(error != nil)) {
                Button("OK") { error = nil }
            } message: {
                Text(error ?? "")
            }
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Un día menos")
                .font(.system(size: 34, weight: .semibold, design: .rounded))
            Text("Tus cuentas atrás, en un solo lugar.")
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.bottom, 6)
    }

    private var emptyState: some View {
        GlassCard {
            VStack(alignment: .leading, spacing: 10) {
                Text("Crea tu primer evento")
                    .font(.headline)
                Text("Añade fecha, y guarda fotos y vídeos dentro.")
                    .foregroundStyle(.secondary)
                PrimaryButton(title: "Nuevo evento", systemImage: "plus") {
                    showCreate = true
                }
            }
        }
        .padding(.top, 10)
    }

    private func reload() async {
        guard auth.sessionUserId != nil else { return }
        isLoading = true
        defer { isLoading = false }
        do {
            events = try await EventsService.fetchEvents()
        } catch {
            self.error = error.localizedDescription
        }
    }
}

private struct EventRow: View {
    let event: UDMEvent

    var body: some View {
        let tint = Brand.accent(hex: event.color)

        GlassCard {
            HStack(spacing: 14) {
                Circle()
                    .fill(tint)
                    .frame(width: 12, height: 12)

                VStack(alignment: .leading, spacing: 4) {
                    Text(event.title).font(.headline).foregroundStyle(.primary)
                    if let subtitle = event.subtitle, !subtitle.isEmpty {
                        Text(subtitle).font(.subheadline).foregroundStyle(.secondary)
                    }
                    Text(event.target_at.formatted(date: .abbreviated, time: .shortened))
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
        }
    }
}
