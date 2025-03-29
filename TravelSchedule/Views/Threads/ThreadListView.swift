import SwiftUI

struct ThreadListView: View {
    @Binding var schedule: Schedule
    @State var currentFilter = Filter()

    private var departure: String {
        schedule.destinations[.departure].cityTitle + " (" + schedule.destinations[.departure].stationTitle + ") "
    }

    private var arrival: String {
        schedule.destinations[.arrival].cityTitle + " (" + schedule.destinations[.arrival].stationTitle + ") "
    }

    private var filteredRoutes: [Route] {
        let complexRoutes = currentFilter.isWithTransfers
            ? schedule.routes
            : schedule.routes.filter { $0.isDirect == true }
        var allRoutes = currentFilter.isAtNight
            ? complexRoutes.filter { $0.departureTime.starts(with: /0[0-5]/) }
            : []
        allRoutes += currentFilter.isMorning
        ? complexRoutes.filter { $0.departureTime.starts(with: /0[6-9]/) || $0.departureTime.starts(with: /1[0-1]/) }
        : []
        allRoutes += currentFilter.isAfternoon
            ? complexRoutes.filter { $0.departureTime.starts(with: /1[2-8]/) }
            : []
        allRoutes += currentFilter.isEvening
            ? complexRoutes.filter { $0.departureTime.starts(with: /19/) || $0.departureTime.starts(with: /2[0-4]/) }
            : []
        return allRoutes.sorted { $0.date < $1.date }
    }

    var body: some View {
        VStack(spacing: 0) {
            (Text(departure) + Text(Image.iconArrow).baselineOffset(-1) + Text(arrival))
                .font(.boldMedium)

            if filteredRoutes.isEmpty {
                EmptySearchView(notification: "Вариантов нет")
            } else {
                ScrollView(.vertical) {
                    ForEach(filteredRoutes) { route in
                        if let carrier = schedule.carriers.first(where: { $0.id == route.carrierID }) {
                            NavigationLink {
                                CarrierView(carrier: carrier)
                            } label: {
                                ThreadView(route: route, carrier: carrier)
                            }
                        }
                    }
                }
                .padding(.vertical, .spacerL)
            }

            Spacer()

            NavigationLink {
                FilterView(filter: $currentFilter)
            } label: {
                HStack(alignment: .center, spacing: 4) {
                    Text("Уточнить время")
                        .font(.boldSmall)
                    Image(systemName: "circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 8, height: 8)
                        .foregroundColor(currentFilter == Filter.fullSearch ? .clear : .ypRed)
                }
                .frame(maxWidth: .infinity, maxHeight: 60)
                .background(.ypBlue)
                .foregroundStyle(.ypWhite)
                .clipShape(RoundedRectangle(cornerRadius: 16))
            }
        }
        .padding(.horizontal, .spacerL)
        .setCustomNavigationBar()
    }
}

#Preview {
    NavigationStack {
        ThreadListView(
            schedule: .constant(Schedule.sampleData)
        )
    }
}
