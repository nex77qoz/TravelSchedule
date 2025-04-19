import SwiftUI

struct RadioButtonView: View {
    @Binding var isOn: Bool

    var body: some View {
        VStack(spacing: 0) {
            radioButton(.on, binding: $isOn)
            radioButton(.off, binding: $isOn.not)
        }
    }
}

private extension RadioButtonView {
    enum RadioButtonState {
        case on, off

        var title: String {
            switch self {
                case .on:  return String(localized: "Да")
                case .off: return String(localized: "Нет")
            }
        }
    }

    @ViewBuilder
    func radioButton(_ state: RadioButtonState, binding: Binding<Bool>) -> some View {
        Toggle(state.title, isOn: binding)
            .setRowElement()
            .toggleStyle(.radioButton)
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
