import SwiftUI

// Модификатор для установки кастомной кнопки "Назад" + свайп для возврата
struct SetCustomNavBackButton: ViewModifier {
    @Environment(\.dismiss) var dismiss 

    @ViewBuilder
    @MainActor
    func body(content: Content) -> some View {
        content
            .navigationBarBackButtonHidden(true) // Скрываем стандартную кнопку "Назад"
            .toolbar {
                // Кастомная кнопка "Назад" слева в тулбаре
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.backward")
                            .imageScale(.large)
                            .foregroundColor(.ypBlackDuo)
                    }
                }
            }
            .contentShape(Rectangle()) // Чтобы свайп срабатывал по всей области
            .gesture(
                // Поддержка свайпа вправо как альтернативы кнопке "Назад"
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
