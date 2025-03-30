import SwiftUI

// Кастомный стиль для отображения чекбокса (вместо стандартного переключателя)
struct CheckboxToggleStyle: ToggleStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        HStack(spacing: 0) {
            configuration.label
            Spacer()
            (configuration.isOn ? Image.iconCheckboxOn : Image.iconCheckboxOff)
                .resizable()
                .frame(width: 24, height: 24)
                .onTapGesture {
                    configuration.isOn.toggle()
                }
        }
    }
}
