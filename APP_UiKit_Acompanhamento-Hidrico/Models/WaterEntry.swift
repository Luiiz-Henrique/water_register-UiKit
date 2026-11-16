import Foundation

/// Representa uma única entrada de água ingerida pelo usuário.
struct WaterEntry: Codable, Equatable {
    let id: UUID
    let amount: Int // quantidade em mililitros
    let date: Date
    let clock: Date

    init(amount: Int, date: Date = Date(), clock: Date = Date()) {
        self.id = UUID()
        self.amount = amount
        self.date = date
        self.clock = clock
    }
}
