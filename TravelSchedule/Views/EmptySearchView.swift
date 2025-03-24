import SwiftUI

struct EmptySearchView: View {
    @State var notification: String

    var body: some View {
        Spacer()
        Text(notification)
            .font(.boldMedium)
        Spacer()
    }
}

#Preview {
    EmptySearchView(notification: "Тут пусто")
}
