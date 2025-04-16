import SwiftUI

struct SearchResultEmptyView: View {
    let notification: String

    var body: some View {
        Spacer()
        Text(notification)
            .font(.boldMedium)
        Spacer()
    }
}

#Preview {
    SearchResultEmptyView(notification: "Nothing is here")
}
