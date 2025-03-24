import SwiftUI

struct CarrierCardView: View {
    let carrier: Carrier
    
    var body: some View {
        VStack(spacing: 20) {
            Text(carrier.title)
                .font(.largeTitle)
            if let address = carrier.address {
                Text(address)
            } else {
                Text("Нет подробной информации")
                    .foregroundColor(.gray)
            }
            Spacer()
        }
        .padding()
        .navigationBarTitle("Карточка перевозчика", displayMode: .inline)
    }
}
