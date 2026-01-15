import SwiftUI

struct BrandField: View {
    let title: String
    @Binding var text: String
    var isSecure: Bool = false

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title).font(.footnote).foregroundStyle(.secondary)
            if isSecure {
                SecureField("", text: $text)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    .padding(14)
                    .background(Brand.subtle, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
            } else {
                TextField("", text: $text)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    .padding(14)
                    .background(Brand.subtle, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
            }
        }
    }
}
