import SwiftUI

struct MainSearchView: View {
    @Binding var schedule: Schedule
    @Binding var navPath: [ViewsChanger]
    @Binding var direction: Int

    private let dummyDirection = ["Откуда", "Куда"]

    // Проверка, заполнено ли направление "откуда"
    private var isDepartureReady: Bool {
        !schedule.destinations[.departure].cityTitle.isEmpty &&
        !schedule.destinations[.departure].stationTitle.isEmpty
    }

    // Проверка, заполнено ли направление "куда"
    private var isArrivalReady: Bool {
        !schedule.destinations[.arrival].cityTitle.isEmpty &&
        !schedule.destinations[.arrival].stationTitle.isEmpty
    }

    var body: some View {
        HStack(alignment: .center, spacing: 16) {
            VStack(alignment: .leading, spacing: 0) {
                ForEach(0 ..< 2) { item in
                    // Формируем текст для кнопки в зависимости от наличия данных
                    let isCityEmpty = schedule.destinations[item].cityTitle.isEmpty
                    let isStationEmpty = schedule.destinations[item].stationTitle.isEmpty

                    let destinationLabel = isCityEmpty
                        ? dummyDirection[item]
                        : schedule.destinations[item].cityTitle +
                          (isStationEmpty ? "" : " (\(schedule.destinations[item].stationTitle))")

                    NavigationLink(value: ViewsChanger.cityView) {
                        SelectableRowView(
                            title: destinationLabel,
                            isDimmed: isCityEmpty
                        )
                        .background(Color.ypWhite)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                    .simultaneousGesture(TapGesture().onEnded {
                        // Запоминаем, какой пункт (0 или 1) был выбран
                        direction = item
                    })
                }
            }
            .background(.ypWhite)
            .foregroundColor(.ypBlack)
            .clipShape(RoundedRectangle(cornerRadius: 20))

            // Кнопка для обмена местами "откуда" и "куда"
            ZStack {
                Circle()
                    .foregroundColor(.ypWhite)
                    .frame(width: 36)

                Button {
                    (schedule.destinations[.departure], schedule.destinations[.arrival]) =
                    (schedule.destinations[.arrival], schedule.destinations[.departure])
                } label: {
                    Image.iconSearchSwap
                        .foregroundColor(.ypBlue)
                }
            }
        }
        .padding(.spacerL)
        .background(.ypBlue)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .frame(height: 128)
        .padding(.top, .spacerXL)
        .padding(.horizontal, .spacerL)

        // Кнопка "Найти" доступна только если оба пункта заполнены
        if isDepartureReady && isArrivalReady {
            NavigationLink(value: ViewsChanger.routeView) {
                Text("Найти")
                    .font(.boldSmall)
                    .foregroundStyle(.ypWhite)
                    .frame(width: 150, height: 60)
                    .background(.ypBlue)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .padding(.spacerL)
            }
        }

        Spacer()
    }
}

#Preview {
    NavigationStack {
        MainSearchView(
            schedule: .constant(Schedule.sampleData),
            navPath: .constant([]),
            direction: .constant(0)
        )
    }
}
