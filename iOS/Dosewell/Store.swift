import Foundation
import Combine

final class DosewellStore: ObservableObject {
    static let freeTierLimit = 20

    @Published var doses: [MedicationDose] = [] { didSet { persist() } }

    private let fileURL: URL

    init() {
        let support = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0]
        try? FileManager.default.createDirectory(at: support, withIntermediateDirectories: true)
        fileURL = support.appendingPathComponent("dosewellstore.json")
        load()
    }

    var isAtFreeLimit: Bool { doses.count >= Self.freeTierLimit }

    func canAdd(isPro: Bool) -> Bool {
        isPro || doses.count < Self.freeTierLimit
    }

    func add(_ entry: MedicationDose, isPro: Bool) -> Bool {
        guard canAdd(isPro: isPro) else { return false }
        doses.append(entry)
        return true
    }

    func remove(at offsets: IndexSet) {
        doses.remove(atOffsets: offsets)
    }

    func update(_ entry: MedicationDose) {
        if let idx = doses.firstIndex(where: { $0.id == entry.id }) {
            doses[idx] = entry
        }
    }

    private func seedIfNeeded() {
        if doses.isEmpty {
            doses = [Self.sampleSeed]
        }
    }

    private func persist() {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        if let data = try? encoder.encode(PersistedState(doses: doses)) {
            try? data.write(to: fileURL)
        }
    }

    private func load() {
        guard let data = try? Data(contentsOf: fileURL) else {
            seedIfNeeded()
            return
        }
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        if let state = try? decoder.decode(PersistedState.self, from: data) {
            self.doses = state.doses
            
        }
        seedIfNeeded()
    }

    struct PersistedState: Codable {
        var doses: [MedicationDose]
        
    }
    static let sampleSeed = MedicationDose(petName: "Buddy", medicationName: "Heartworm Preventive", dose: "1 tablet", timeGiven: Date(), notes: "")
}
