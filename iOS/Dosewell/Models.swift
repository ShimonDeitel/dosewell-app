import Foundation

struct MedicationDose: Codable, Identifiable, Hashable {
    var id: UUID = UUID()
    var petName: String
    var medicationName: String
    var dose: String
    var timeGiven: Date = Date()
    var notes: String = ""
}
