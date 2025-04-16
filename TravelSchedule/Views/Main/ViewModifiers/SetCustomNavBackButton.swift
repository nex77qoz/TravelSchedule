import SwiftUI

struct SetCustomNavBackButton: ViewModifier {
    @Environment(\.dismiss) var dismiss

    @ViewBuilder
    @MainActor
    func body(content: Content) -> some View {
        content
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image.iconBackward
                            .imageScale(.large)
                            .foregroundStyle(Color.ypBlackDuo)
                    }
                    .padding(.leading, -.S)
                    .padding(.trailing, .S)
                }
            }
            .contentShape(Rectangle())
            .gesture(
                DragGesture(coordinateSpace: .local)
                    .onEnded { value in
                        if value.translation.width > .zero
                            && value.translation.height > -30
                            && value.translation.height < 30 {
                            dismiss()
                        }
                    }
            )
    }
}
