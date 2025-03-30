import SwiftUI

struct SelectableRowView: View {
    var title: String
    var subtitle: String?
    var isDimmed: Bool = false
    var rightIcon: Image?

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.regMedium)
                if let subtitle = subtitle {
                    Text(subtitle)
                        .font(.regSmall)
                }
            }

            Spacer()

            if let icon = rightIcon {
                icon
                    .resizable()
                    .frame(width: 16, height: 16)
            }
        }
        .padding(.vertical, .spacerS)
        .padding(.horizontal, .spacerL)
        .frame(maxWidth: .infinity, minHeight: 48)
    }
}
