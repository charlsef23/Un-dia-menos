import SwiftUI
import AVKit

struct MediaViewerView: View {
    let item: UDMEventMedia
    @Environment(\.dismiss) private var dismiss

    @State private var url: URL? = nil
    @State private var isLoading = true
    @State private var error: String? = nil

    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.ignoresSafeArea()

                if isLoading {
                    ProgressView().tint(.white)
                } else if let error {
                    Text(error).foregroundStyle(.white)
                        .padding()
                } else if let url {
                    if item.kind == "video" {
                        VideoPlayer(player: AVPlayer(url: url))
                            .ignoresSafeArea()
                    } else {
                        AsyncImage(url: url) { phase in
                            switch phase {
                            case .empty: ProgressView().tint(.white)
                            case .success(let image):
                                image.resizable().scaledToFit().padding()
                            case .failure:
                                Text("No se pudo cargar la imagen").foregroundStyle(.white)
                            @unknown default:
                                EmptyView()
                            }
                        }
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cerrar") { dismiss() }
                        .foregroundStyle(.white)
                }
            }
            .task { await loadURL() }
        }
    }

    private func loadURL() async {
        isLoading = true
        defer { isLoading = false }
        do {
            url = try await MediaService.signedURL(path: item.storage_path, expiresIn: 60 * 30)
        } catch {
            self.error = error.localizedDescription
        }
    }
}
