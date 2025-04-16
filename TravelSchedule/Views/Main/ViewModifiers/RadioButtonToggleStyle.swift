import SwiftUI

struct RadioButtonToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack(spacing: .zero) {
            configuration.label
            Spacer()
            (configuration.isOn ? Image.iconRadioOn : Image.iconRadioOff)
                .resizable()
                .frame(width: .XXL, height: .XXL)
                .onTapGesture { configuration.isOn.toggle() }
        }
    }
}

extension ToggleStyle where Self == RadioButtonToggleStyle {
    static var radioButton: Self { Self() }
}
