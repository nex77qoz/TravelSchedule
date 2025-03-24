import SwiftUI

@main
struct TravelScheduleApp: App {
    @State private var schedule = Schedule.sampleData
    @State private var darkMode = false

    var body: some Scene {
        WindowGroup {
            MainTabView(schedule: $schedule, darkMode: $darkMode)
                .environment(\.colorScheme, darkMode ? .dark : .light)
        }
    }
}
