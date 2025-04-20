import SwiftUI

struct SetCustomNavBackButton: ViewModifier {
    @Environment(\.dismiss) private var dismiss

    private enum Constants {
        static let verticalTolerance: CGFloat = 30
    }

    func body(content: Content) -> some View {
        content
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: dismiss.callAsFunction) {
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
                        if value.translation.width > 0,
                           abs(value.translation.height) < Constants.verticalTolerance {
                            dismiss()
                        }
                    }
            )
    }
}
