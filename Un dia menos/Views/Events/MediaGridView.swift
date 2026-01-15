import SwiftUI
import PhotosUI
import AVKit
import UniformTypeIdentifiers

struct MediaGridView: View {
    @EnvironmentObject var auth: AuthService

    let event: UDMEvent
    @Binding var media: [UDMEventMedia]
    @Binding var isLoading: Bool
    let onError: (String) -> Void

    @State private var pickerItem: PhotosPickerItem? = nil
    @State private var showViewer: UDMEventMedia? = nil

    private let columns = [GridItem(.adaptive(minimum: 110), spacing: 10)]

    var body: some View {
        GlassCard {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text("Recuerdos")
                        .font(.headline)

                    Spacer()

                    PhotosPicker(selection: $pickerItem, matching: .any(of: [.images, .videos])) {
                        Label("Añadir", systemImage: "plus")
                            .font(.subheadline)
                    }
                }

                if isLoading {
                    ProgressView().padding(.vertical, 10)
                } else if media.isEmpty {
                    Text("Sube fotos y vídeos para este evento.")
                        .foregroundStyle(.secondary)
                        .font(.subheadline)
                        .padding(.vertical, 6)
                } else {
                    LazyVGrid(columns: columns, spacing: 10) {
                        ForEach(media) { item in
                            MediaTile(item: item) {
                                showViewer = item
                            } onDelete: {
                                Task { await delete(item) }
                            }
                        }
                    }
                }
            }
        }
        .sheet(item: $showViewer) { item in
            MediaViewerView(item: item)
        }
        .onChange(of: pickerItem) { _, newValue in
            guard let newValue else { return }
            Task { await upload(newValue) }
        }
    }

    private func upload(_ item: PhotosPickerItem) async {
        guard let userId = auth.sessionUserId else { return }
        isLoading = true
        defer { isLoading = false }

        do {
            // Detect kind
            let kind: String
            if item.supportedContentTypes.contains(where: { $0.conforms(to: .movie) }) {
                kind = "video"
            } else {
                kind = "image"
            }

            // Load data
            guard let data = try await item.loadTransferable(type: Data.self) else {
                throw NSError(domain: "Picker", code: -1, userInfo: [NSLocalizedDescriptionKey: "No se pudo leer el archivo"])
            }

            let mediaId = UUID()
            let ext = (kind == "video") ? "mp4" : "jpg"
            let contentType = (kind == "video") ? "video/mp4" : "image/jpeg"
            let path = "\(userId.uuidString)/\(event.id.uuidString)/\(mediaId.uuidString).\(ext)"

            try await MediaService.upload(data: data, contentType: contentType, path: path)
            let row = try await MediaService.addMediaRow(eventId: event.id, userId: userId, kind: kind, path: path)

            media.insert(row, at: 0)
            pickerItem = nil
        } catch {
            onError(error.localizedDescription)
        }
    }

    private func delete(_ item: UDMEventMedia) async {
        isLoading = true
        defer { isLoading = false }
        do {
            try await MediaService.removeFromStorage(path: item.storage_path)
            try await MediaService.deleteMediaRow(mediaId: item.id)
            media.removeAll { $0.id == item.id }
        } catch {
            onError(error.localizedDescription)
        }
    }
}

private struct MediaTile: View {
    let item: UDMEventMedia
    let onTap: () -> Void
    let onDelete: () -> Void

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(Color(.secondarySystemBackground))

            VStack(spacing: 8) {
                Image(systemName: item.kind == "video" ? "play.rectangle.fill" : "photo.fill")
                    .font(.title2)
                    .foregroundStyle(.secondary)
                Text(item.kind == "video" ? "Vídeo" : "Foto")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .frame(height: 110)
        .overlay(alignment: .topTrailing) {
            Button(role: .destructive, action: onDelete) {
                Image(systemName: "xmark.circle.fill")
                    .foregroundStyle(.secondary)
                    .padding(8)
            }
            .buttonStyle(.plain)
        }
        .onTapGesture(perform: onTap)
    }
}
