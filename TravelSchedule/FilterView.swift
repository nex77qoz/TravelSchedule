import SwiftUI

struct FilterView: View {
    @Environment(\.dismiss) var dismiss
    @State private var selectedDate = Date()
    @State private var isExpress: Bool = false
    
    let onFilterApplied: (Date, Bool) -> Void
    
    var body: some View {
        NavigationView {
            Form {
                DatePicker("Выберите дату", selection: $selectedDate, displayedComponents: .date)
                Toggle("Экспресс", isOn: $isExpress)
            }
            .navigationBarTitle("Фильтры", displayMode: .inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Отмена") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Применить") {
                        onFilterApplied(selectedDate, isExpress)
                        dismiss()
                    }
                }
            }
        }
    }
}
