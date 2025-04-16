import SwiftUI

struct CheckboxView: View {
    let type: CheckboxType
    @Binding var isOn: Bool

    var body: some View {
        Toggle(type.title, isOn: $isOn)
            .setRowElement()
            .toggleStyle(.checkBox)
    }
}

extension CheckboxView {
    enum CheckboxType {
        case morning, afternoon, evening, night

        var title: String {
            switch self {
                case .morning: return String(localized: "Утро 06:00 - 11:59")
                case .afternoon: return String(localized: "День 12:00 - 18:59")
                case .evening: return String(localized: "Вечер 19:00 - 23:59")
                case .night: return String(localized: "Ночь 00:00 - 05:59")
            }
        }
    }
}

#Preview {
    VStack {
        CheckboxView(type: .morning, isOn: .constant(Filter.fullSearch.isAtMorning))
        CheckboxView(type: .night, isOn: .constant(Filter.customSearch.isAtMorning))
    }
}
