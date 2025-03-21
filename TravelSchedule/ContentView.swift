import SwiftUI
import UIKit

struct ContentView: View {
    @StateObject private var viewModel = TravelScheduleViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                ScrollView {
                    VStack(alignment: .leading, spacing: 10) {
                        ForEach(viewModel.testResults) { result in
                            HStack(alignment: .top) {
                                Text(result.status)
                                    .font(.system(size: 24))
                                    .padding(.trailing, 5)
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(result.title)
                                        .font(.headline)
                                    
                                    if !result.details.isEmpty {
                                        Text(result.details)
                                            .font(.subheadline)
                                            .foregroundColor(.secondary)
                                    }
                                }
                            }
                            .padding(.vertical, 5)
                            .contextMenu {
                                Button(action: {
                                    let fullText = "\(result.status) \(result.title)\n\(result.details)"
                                    UIPasteboard.general.string = fullText
                                }) {
                                    Label("Копировать результат", systemImage: "doc.on.doc")
                                }
                            }
                            
                            Divider()
                        }
                        
                        if viewModel.isLoading {
                            HStack {
                                Spacer()
                                ProgressView()
                                    .padding()
                                Spacer()
                            }
                        }
                    }
                    .padding()
                }
                
                Button(action: {
                    viewModel.runTests()
                }) {
                    HStack {
                        Image(systemName: "network")
                        Text("Запустить тесты API")
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(viewModel.isLoading ? Color.gray : Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
                .disabled(viewModel.isLoading)
                .padding()
            }
            .navigationTitle("Тесты API расписания Яндекса")
            .alert(isPresented: Binding<Bool>(
                get: { viewModel.errorMessage != nil },
                set: { if !$0 { viewModel.errorMessage = nil } }
            )) {
                Alert(title: Text("Ошибка"), message: Text(viewModel.errorMessage ?? ""), dismissButton: .default(Text("OK")))
            }
        }
    }
}

struct TestResult: Identifiable {
    let id = UUID()
    let title: String
    let status: String // "✅", "❌", "⏱️", "ℹ️"
    let details: String
}
