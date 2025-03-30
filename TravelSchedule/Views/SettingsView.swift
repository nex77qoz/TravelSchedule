import SwiftUI

struct SettingsView: View {
    @Binding var darkMode: Bool

    var body: some View {
        VStack(spacing: 0) {
            ToggleRowView(title: "Тёмная тема", isOn: $darkMode)
                .tint(.ypBlue)

            NavigationLink {
                AgreementView(darkMode: darkMode)
            } label: {
                SelectableRowView(title: "Пользовательское соглашение")
                    .background(.ypWhiteDuo)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }

            Spacer()

            VStack(alignment: .center, spacing: 16) {
                Text("Приложение использует API «Яндекс.Расписания»")
                Text("Версия 1.0")
            }
            .font(.regSmall)
            .frame(minHeight: 44)
        }
        .padding(.top, .spacerXXL)
        .padding(.bottom, 0)
        .background(.ypWhiteDuo)
        .foregroundColor(.ypBlackDuo)
    }
}
