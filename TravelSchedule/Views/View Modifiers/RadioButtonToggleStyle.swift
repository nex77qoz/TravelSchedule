import SwiftUI

// Кастомный стиль для радиокнопки (используется вместо стандартного Toggle)
struct RadioButtonToggleStyle: ToggleStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        HStack(spacing: 0) {
            configuration.label
            Spacer()
            (configuration.isOn ? Image.iconRadioOn : Image.iconRadioOff)
                .resizable()
                .frame(width: 24, height: 24)
                .onTapGesture {
                    configuration.isOn.toggle()
                }
        }
    }
}
