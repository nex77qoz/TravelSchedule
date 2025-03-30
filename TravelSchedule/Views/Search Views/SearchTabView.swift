import SwiftUI

struct SearchTabView: View {
    
    // MARK: - Свойства
    @Binding var stories: [Story]
    @Binding var schedule: Schedule
    @Binding var navPath: [ViewsChanger]
    @Binding var direction: Int

    // MARK: - Основное представление
    var body: some View {
        VStack(spacing: 0) {
            // Список историй
            PreviewStoriesView(stories: $stories)

            // Основной блок с выбором направлений и кнопкой "Найти"
            MainSearchView(
                schedule: $schedule,
                navPath: $navPath,
                direction: $direction
            )
        }
    }
}

#Preview {
    NavigationStack {
        SearchTabView(
            stories: .constant(Story.mockData),
            schedule: .constant(Schedule.sampleData),
            navPath: .constant([]),
            direction: .constant(0)
        )
    }
}
