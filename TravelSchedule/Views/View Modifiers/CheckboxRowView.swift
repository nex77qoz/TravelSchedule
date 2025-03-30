import SwiftUI

struct CheckboxRowView: View {
    var title: String
    @Binding var isOn: Bool

    var body: some View {
        Toggle(title, isOn: $isOn)
            .toggleStyle(CheckboxToggleStyle())
            .padding(.spacerL)
            .frame(maxWidth: .infinity, minHeight: 48)
            .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}
