import SwiftUI

struct SearchTabView: View {
    @Binding var stories: [Story]
    @Binding var schedule: Schedule
    @Binding var navPath: [ViewsChanger]
    @Binding var direction: Int

    var body: some View {
        VStack(spacing: 0) {
            // Список историй
            StoriesListView(stories: $stories)

            // Основной блок с выбором направлений и кнопкой "Найти"
            MainSearchView(schedule: $schedule, navPath: $navPath, direction: $direction)

            Spacer()
        }
    }
}

#Preview {
    NavigationStack {
        SearchTabView(
            stories: .constant(Story.sampleData),
            schedule: .constant(Schedule.sampleData),
            navPath: .constant([]),
            direction: .constant(0)
        )
    }
}
