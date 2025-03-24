import SwiftUI

struct SettingsView: View {
    @AppStorage("isDarkMode") private var isDarkMode: Bool = false
    @State private var showUserAgreement: Bool = false
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Тема")) {
                    Toggle("Тёмная тема", isOn: $isDarkMode)
                }
                
                Section {
                    Button("Пользовательское соглашение") {
                        showUserAgreement = true
                    }
                }
            }
            .navigationBarTitle("Настройки", displayMode: .inline)
            .fullScreenCover(isPresented: $showUserAgreement) {
                UserAgreementView {
                    showUserAgreement = false
                }
            }
            .preferredColorScheme(isDarkMode ? .dark : .light)
        }
    }
}
