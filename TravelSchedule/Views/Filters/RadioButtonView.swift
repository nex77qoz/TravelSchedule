import SwiftUI

struct RadioButtonView: View {
    @Binding var isOn: Bool

    var body: some View {
        VStack(spacing: .zero) {
            Toggle(RadioButtonState.on.title, isOn: $isOn)
                .setRowElement()
                .toggleStyle(.radioButton)

            Toggle(RadioButtonState.off.title, isOn: $isOn.not)
                .setRowElement()
                .toggleStyle(.radioButton)
        }
    }
}

extension RadioButtonView {
    enum RadioButtonState {
        case on, off

        var title: String {
            switch self {
                case .on: return String(localized: "Да")
                case .off: return String(localized: "Нет")
            }
        }
    }
}

#Preview {
    VStack {
        RadioButtonView(isOn: .constant(true))
            .padding()
        RadioButtonView(isOn: .constant(false))
            .padding()
    }
}
