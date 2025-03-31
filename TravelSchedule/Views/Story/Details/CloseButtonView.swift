import SwiftUI

struct CloseButton: View {
    
    // MARK: - Свойства
    let action: () -> Void

    // MARK: - Основное представление
    var body: some View {
        Button {
            action()
        } label: {
            ZStack {
                Circle()
                    .foregroundStyle(Color.ypWhite)
                Image.cancel
                    .resizable()
                    .foregroundStyle(Color.ypBlack)
            }
            .frame(width: .button, height: .button)
        }
    }
}

#Preview {
    CloseButton { }
        .padding()
        .background(Color.ypBlue)
}
