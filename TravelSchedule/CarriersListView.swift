import SwiftUI

struct CarriersListView: View {
    let carriers: [Carrier] = [
        Carrier(code: 1, title: "Перевозчик 1", codes: nil, address: nil, url: nil, email: nil, contacts: nil, phone: nil, logo: nil),
        Carrier(code: 2, title: "Перевозчик 2", codes: nil, address: nil, url: nil, email: nil, contacts: nil, phone: nil, logo: nil),
        Carrier(code: 3, title: "Перевозчик 3", codes: nil, address: nil, url: nil, email: nil, contacts: nil, phone: nil, logo: nil)
    ]			    
    var body: some View {
        NavigationView {
            List(carriers) { carrier in
                NavigationLink(destination: CarrierCardView(carrier: carrier)) {
                    Text(carrier.title)
                }
            }			
            .navigationBarTitle("Перевозчики", displayMode: .inline)
        }
    }
}
