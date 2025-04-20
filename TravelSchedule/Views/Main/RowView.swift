import SwiftUI

struct RowView: View {
    @State var title: String

    var body: some View {
        HStack(spacing: 0) {
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
