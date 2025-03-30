import SwiftUI

struct RadioRowView: View {
    var title: String
    @Binding var isOn: Bool

    var body: some View {
        Toggle(title, isOn: $isOn)
            .toggleStyle(RadioButtonToggleStyle())
            .padding(.spacerL)
    }
}
