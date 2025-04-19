import SwiftUI

struct SettingsScreen: View {
    @EnvironmentObject var viewModel: SettingsViewModel

    var body: some View {
        VStack(spacing: 0) {
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
    var switchView: some View {
        Toggle(SettingsViewModel.Titles.darkMode, isOn: $viewModel.darkMode)
            .setRowElement()
            .tint(Color.ypBlue)
    }

    var agreementView: some View {
            NavigationLink {
                AgreementView(darkMode: viewModel.darkMode)
            } label: {
                RowView(title: SettingsViewModel.Titles.agreement)
            }
            .setRowElement()
        }

    var footerView: some View {
        VStack(alignment: .center, spacing: .L) {
            Text(viewModel.copyrightInfo)
            Text(SettingsViewModel.Titles.version)
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
