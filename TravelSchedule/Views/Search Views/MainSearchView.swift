import SwiftUI

struct MainSearchView: View {
    // MARK: - Свойства
    @Binding var schedule: Schedule
    @Binding var navPath: [ViewsChanger]
    @Binding var direction: Int

    private let dummyDirection = ["Откуда", "Куда"]

    private var isDepartureReady: Bool {
        !schedule.destinations[.departure].cityTitle.isEmpty &&
        !schedule.destinations[.departure].stationTitle.isEmpty
    }

    private var isArrivalReady: Bool {
        !schedule.destinations[.arrival].cityTitle.isEmpty &&
        !schedule.destinations[.arrival].stationTitle.isEmpty
    }

    private var isFindButtonHidden: Bool {
        !(isDepartureReady && isArrivalReady)
    }

    // MARK: - Интерфейс
    var body: some View {
        ZStack {
            Color.ypWhiteDuo
                .ignoresSafeArea()

            VStack {
                // MARK: - Выбор направления
                HStack(spacing: 16) {
                    VStack(alignment: .leading, spacing: 0) {
                        ForEach(0 ..< 2) { item in
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
                                direction = item
                            })
                        }
                    }
                    .background(.ypWhite)
                    .foregroundColor(.ypBlack)
                    .clipShape(RoundedRectangle(cornerRadius: 20))

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

                // MARK: - Кнопка поиска
                NavigationLink(value: ViewsChanger.routeView) {
                    Text("Найти")
                        .font(.boldSmall)
                        .foregroundStyle(.ypWhite)
                        .frame(width: 150, height: 60)
                        .background(.ypBlue)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .padding(.spacerL)
                }
                .opacity(isFindButtonHidden ? 0 : 1)
                .disabled(isFindButtonHidden)
                .animation(.easeInOut(duration: 0.3), value: isFindButtonHidden)

                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}
