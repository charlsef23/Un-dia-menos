import SwiftUI

struct EventEditorView: View {
    enum Mode {
        case create
        case edit(UDMEvent)
    }

    @EnvironmentObject var auth: AuthService
    @Environment(\.dismiss) private var dismiss

    let mode: Mode
    let onDone: (UDMEvent) -> Void

    @State private var title = ""
    @State private var subtitle = ""
    @State private var targetAt = Calendar.current.date(byAdding: .day, value: 7, to: .now) ?? .now
    @State private var colorHex = "#FF3B30"

    @State private var isSaving = false
    @State private var error: String? = nil

    var body: some View {
        let isEdit: Bool = {
            if case .edit = mode { return true } else { return false }
        }()

        Form {
            Section("Básico") {
                TextField("Título", text: $title)
                TextField("Subtítulo (opcional)", text: $subtitle)
            }

            Section("Fecha objetivo") {
                DatePicker("Objetivo", selection: $targetAt, displayedComponents: [.date, .hourAndMinute])
            }

            Section("Color") {
                HStack {
                    TextField("#FF3B30", text: $colorHex)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                    Spacer()
                    Circle()
                        .fill(Color(hex: colorHex) ?? .red)
                        .frame(width: 18, height: 18)
                }
                Text("Tip: usa un HEX (ej. #FF3B30) para personalizar cada evento.")
                    .font(.footnote).foregroundStyle(.secondary)
            }

            if let error {
                Section {
                    Text(error).foregroundStyle(.red)
                }
            }
        }
        .navigationTitle(isEdit ? "Editar evento" : "Nuevo evento")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button("Cancelar") { dismiss() }
            }
            ToolbarItem(placement: .topBarTrailing) {
                Button(isSaving ? "Guardando..." : "Guardar") {
                    Task { await save() }
                }
                .disabled(isSaving || title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            }
        }
        .onAppear { hydrate() }
    }

    private func hydrate() {
        switch mode {
        case .create:
            break
        case .edit(let e):
            title = e.title
            subtitle = e.subtitle ?? ""
            targetAt = e.target_at
            colorHex = e.color
        }
    }

    private func save() async {
        guard let userId = auth.sessionUserId else { return }
        isSaving = true; error = nil
        defer { isSaving = false }

        do {
            switch mode {
            case .create:
                let created = try await EventsService.createEvent(
                    userId: userId,
                    title: title,
                    subtitle: subtitle.isEmpty ? nil : subtitle,
                    targetAt: targetAt,
                    color: colorHex
                )
                onDone(created)

            case .edit(var e):
                e.title = title
                e.subtitle = subtitle.isEmpty ? nil : subtitle
                e.target_at = targetAt
                e.color = colorHex
                try await EventsService.updateEvent(event: e)
                onDone(e)
            }
        } catch {
            self.error = error.localizedDescription
        }
    }
}
