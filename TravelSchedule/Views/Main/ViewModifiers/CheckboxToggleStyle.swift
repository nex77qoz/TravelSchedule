import SwiftUI

struct CheckboxToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack(spacing: 0) {
            configuration.label
            Spacer()
            (configuration.isOn ? Image.iconCheckboxOn : Image.iconCheckboxOff)
                .resizable()
                .frame(width: .XXL, height: .XXL)
                .onTapGesture { configuration.isOn.toggle() }
        }
    }
}

extension ToggleStyle where Self == CheckboxToggleStyle {
    static var checkBox: Self { Self() }
}
