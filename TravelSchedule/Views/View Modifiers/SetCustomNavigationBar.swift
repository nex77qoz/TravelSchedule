import SwiftUI

struct SetCustomNavigationBar: ViewModifier {
    @State var title: String

    func body(content: Content) -> some View {
        content
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
            .setCustomNavBackButton()
    }
}
