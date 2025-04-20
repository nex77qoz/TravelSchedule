import SwiftUI

struct SetCustomButton: ViewModifier {
    @State var width: CGFloat?
    @State var padding: Edge.Set

    func body(content: Content) -> some View {
        content
            .font(.boldSmall)
            .foregroundStyle(Color.ypWhite)
            .frame(maxHeight: 60.0)
            .frame(maxWidth: (width != nil) ? width : .infinity)
            .background(Color.ypBlue)
            .clipShape(RoundedRectangle(cornerRadius: .L))
            .padding(padding, .L)
    }
}
