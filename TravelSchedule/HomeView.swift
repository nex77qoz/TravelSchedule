import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Выбор маршрута")
                .font(.title)
                .padding(.top)
            
            VStack(alignment: .leading, spacing: 10) {
                Text("Откуда:")
                    .font(.headline)
                Button {
                    viewModel.cityPickerFor = "from"
                    viewModel.showCityPicker = true
                } label: {
                    HStack {
                        Text(viewModel.fromCity?.title ?? "Выберите город")
                        Spacer()
                        Image(systemName: "chevron.right")
                    }
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(8)
                }
                if viewModel.fromCity != nil {
                    Button {
                        viewModel.stationPickerFor = "from"
                        viewModel.showStationPicker = true
                    } label: {
                        HStack {
                            Text(viewModel.fromStation?.title ?? "Выберите вокзал отправления")
                            Spacer()
                            Image(systemName: "chevron.right")
                        }
                        .padding()
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(8)
                    }
                }
            }
            .padding(.horizontal)
            
            VStack(alignment: .leading, spacing: 10) {
                Text("Куда:")
                    .font(.headline)
                Button {
                    viewModel.cityPickerFor = "to"
                    viewModel.showCityPicker = true
                } label: {
                    HStack {
                        Text(viewModel.toCity?.title ?? "Выберите город")
                        Spacer()
                        Image(systemName: "chevron.right")
                    }
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(8)
                }
                if viewModel.toCity != nil {
                    Button {
                        viewModel.stationPickerFor = "to"
                        viewModel.showStationPicker = true
                    } label: {
                        HStack {
                            Text(viewModel.toStation?.title ?? "Выберите вокзал назначения")
                            Spacer()
                            Image(systemName: "chevron.right")
                        }
                        .padding()
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(8)
                    }
                }
            }
            .padding(.horizontal)
            
            Button {
                viewModel.swapLocations()
            } label: {
                Image(systemName: "arrow.up.arrow.down")
                    .padding()
                    .background(Color(.systemBlue))
                    .foregroundColor(.white)
                    .clipShape(Circle())
            }
            .padding()
            
            Button("Уточнить время") {
                viewModel.showFilter = true
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color(.systemGray5))
            .cornerRadius(8)
            .padding(.horizontal)
            
            Spacer()
            
            Button {
            } label: {
                Text("Найти")
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(viewModel.canSearch ? Color.blue : Color.gray)
                    .cornerRadius(8)
            }
            .padding(.horizontal)
            .disabled(!viewModel.canSearch)
            
            Spacer()
        }
        .navigationBarTitle("Главная", displayMode: .inline)
        .fullScreenCover(isPresented: $viewModel.showCityPicker) {
            CityListView { selectedCity in
                if viewModel.cityPickerFor == "from" {
                    viewModel.fromCity = selectedCity
                    viewModel.fromStation = nil // сброс вокзала, если город изменён
                } else {
                    viewModel.toCity = selectedCity
                    viewModel.toStation = nil
                }
                viewModel.showCityPicker = false
            }
        }
        .fullScreenCover(isPresented: $viewModel.showStationPicker) {
            Group {
                if let city = viewModel.stationPickerFor == "from" ? viewModel.fromCity : viewModel.toCity {
                    StationListView(city: city) { selectedStation in
                        if viewModel.stationPickerFor == "from" {
                            viewModel.fromStation = selectedStation
                        } else {
                            viewModel.toStation = selectedStation
                        }
                        viewModel.showStationPicker = false
                    }
                } else {
                    EmptyView()
                        .onAppear {
                            viewModel.showStationPicker = false
                        }
                }
            }
        }
        .sheet(isPresented: $viewModel.showFilter) {
            FilterView { selectedDate, isExpress in
                viewModel.showFilter = false
            }
        }
    }
}
