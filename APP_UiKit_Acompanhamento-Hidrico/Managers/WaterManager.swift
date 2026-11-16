import Foundation

/// Gerencia armazenamento, lógica de negócio e reset diário.
final class WaterManager {
    static let shared = WaterManager()

    private let userDefaults = UserDefaults.standard
    private let entriesKey = "water_entries"
    private let lastResetKey = "water_last_reset_date"

    private(set) var entries: [WaterEntry] = []

    private init() {
        loadEntries()
        checkDailyReset()
    }

    /// Adiciona uma nova entrada de água.
    func addEntry(amount: Int) {
        let entry = WaterEntry(amount: amount)
        entries.append(entry)
        saveEntries()
    }

    /// Remove uma entrada pelo ID.
    func removeEntry(with id: UUID) {
        entries.removeAll { $0.id == id }
        saveEntries()
    }

    /// Soma total de água ingerida hoje.
    func todayTotal() -> Int {
        todayEntries().reduce(0) { $0 + $1.amount }
    }

    /// Todas as entradas de hoje.
    func todayEntries() -> [WaterEntry] {
        let calendar = Calendar.current
        return entries.filter { calendar.isDateInToday($0.date) }
    }

    /// Verifica se mudou de dia e zera o controle, se necessário.
    private func checkDailyReset() {
        let calendar = Calendar.current
        let now = Date()

        if let lastReset = userDefaults.object(forKey: lastResetKey) as? Date {
            if !calendar.isDateInToday(lastReset) {
                entries = entries.filter { calendar.isDateInToday($0.date) }
                userDefaults.set(now, forKey: lastResetKey)
                saveEntries()
            }
        } else {
            userDefaults.set(now, forKey: lastResetKey)
        }
    }

    private func saveEntries() {
        if let encoded = try? JSONEncoder().encode(entries) {
            userDefaults.set(encoded, forKey: entriesKey)
        }
    }

    private func loadEntries() {
        guard let data = userDefaults.data(forKey: entriesKey),
              let decoded = try? JSONDecoder().decode([WaterEntry].self, from: data) else {
            return
        }
        entries = decoded
    }
}
