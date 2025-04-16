import SwiftUI

struct SettingsScreen: View {
    @EnvironmentObject var viewModel: SettingsViewModel

    var body: some View {
        VStack(spacing: .zero) {
            switchView
            agreementView
            Spacer()
            footerView
        }
        .padding(.vertical, .XXL)
        .foregroundStyle(Color.ypBlackDuo)
    }
}

private extension SettingsScreen {
    enum Titles {
        static let darkMode = "Тёмная тема"
        static let agreement = "Пользовательское соглашение"
        static let version = "Версия \(Bundle.main.appVersionLong).\(Bundle.main.appBuild)"
    }

    var switchView: some View {
        Toggle(Titles.darkMode, isOn: $viewModel.darkMode)
            .setRowElement()
            .tint(Color.ypBlue)
    }

    var agreementView: some View {
            NavigationLink {
                AgreementView(darkMode: viewModel.darkMode)
            } label: {
                RowView(title: Titles.agreement)
            }
            .setRowElement()
        }

    var footerView: some View {
        VStack(alignment: .center, spacing: .L) {
            Text(viewModel.copyrightInfo)
            Text(Titles.version)
        }
        .font(.regSmall)
        .frame(minHeight: 44.0)
    }
}

#Preview {
    NavigationStack {
        SettingsScreen()
            .environmentObject(SettingsViewModel(networkService: NetworkService()))
    }
}
