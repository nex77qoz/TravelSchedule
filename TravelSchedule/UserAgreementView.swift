import SwiftUI

struct UserAgreementView: View {
    let onDismiss: () -> Void
    
    var body: some View {
        NavigationView {
            ScrollView {
                Text("""
                Здесь текст пользовательского соглашения.
                """)
                .padding()
            }
            .navigationBarTitle("Пользовательское соглашение", displayMode: .inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Закрыть") {
                        onDismiss()
                    }
                }
            }
        }
    }
}
