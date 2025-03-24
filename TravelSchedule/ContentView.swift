import SwiftUI

struct ContentView: View {
    @State private var isActive: Bool = false
    
    var body: some View {
        Group {
            if isActive {
                MainTabView()
            } else {
                SplashView()
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                withAnimation {
                    isActive = true
                }
            }
        }
    }
}
