import SwiftUI

@main
struct TravelScheduleApp: App {
    @StateObject var settings = SettingsViewModel(networkService: NetworkService())

    var body: some Scene {
        WindowGroup {
            MainTabView(
                destinationsViewModel: SearchScreenViewModel(),
                rootViewModel: MainViewModel(networkService: NetworkService())
            )
                .environmentObject(settings)
                .environment(\.colorScheme, settings.darkMode ? .dark : .light)
        }
    }
}
