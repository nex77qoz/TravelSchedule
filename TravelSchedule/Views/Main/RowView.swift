import SwiftUI

struct RowView: View {
    @State var title: String

    var body: some View {
        HStack(spacing: .zero) {
            Text(title)
                .font(.regMedium)
            Spacer()
            Image.iconForward
                .imageScale(.large)
        }
    }
}

#Preview {
    RowView(title: "Moscow")
}
