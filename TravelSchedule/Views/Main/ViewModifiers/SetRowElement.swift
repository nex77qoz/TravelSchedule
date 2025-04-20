import SwiftUI

struct SetRowElement: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.regMedium)
            .padding(.horizontal, .L)
            .frame(maxWidth: .infinity, maxHeight: 60.0)
    }
}
