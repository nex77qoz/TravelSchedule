import SwiftUI

struct MainTabView: View {
    @Binding var schedule: Schedule
    @Binding var darkMode: Bool
    
    @State private var navPath: [ViewsChanger] = []
    @State private var direction: Int = .departure
    @State private var stories: [Story] = Story.mockData
    
    var body: some View {
        NavigationStack(path: $navPath) {
            ZStack {
                TabView {
                    SearchTabView(
                        stories: $stories,
                        schedule: $schedule,
                        navPath: $navPath,
                        direction: $direction
                    )
                    .tabItem {
                        Image.iconTabSearch
                    }

                    SettingsView(darkMode: $darkMode)
                        .tabItem {
                            Image.iconTabSettings
                        }
                }
            }
            .toolbar(.visible, for: .tabBar)
            .accentColor(darkMode ? .white : .black)
            .navigationDestination(for: ViewsChanger.self) { pathValue in
                switch pathValue {
                case .cityView:
                    CityView(schedule: $schedule, navPath: $navPath, direction: $direction)
                        .toolbar(.hidden, for: .tabBar)

                case .stationView:
                    StationView(schedule: $schedule, navPath: $navPath, direction: $direction)
                        .toolbar(.hidden, for: .tabBar)

                case .routeView:
                    ThreadListView(schedule: $schedule)
                        .toolbar(.hidden, for: .tabBar)
                }
            }
        }
    }
}

#Preview {
    MainTabView(schedule: .constant(Schedule.sampleData), darkMode: .constant(false))
}
