import Foundation
import Combine

@MainActor
final class Store: ObservableObject {
    @Published var items: [Job] = []
    @Published var isPro: Bool = false

    static let freeLimit = 12

    private let fileURL: URL = {
        let dir = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0]
        try? FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
        return dir.appendingPathComponent("framebook_items.json")
    }()

    init() {
        load()
        if items.isEmpty {
            items = [
            Job(title: "Piece title 1", width: 10, height: 10, matSize: "Mat size (in) 1", molding: "Molding style 1", glassType: "Glass type 1"),
            Job(title: "Piece title 2", width: 13, height: 13, matSize: "Mat size (in) 2", molding: "Molding style 2", glassType: "Glass type 2"),
            Job(title: "Piece title 3", width: 16, height: 16, matSize: "Mat size (in) 3", molding: "Molding style 3", glassType: "Glass type 3")
            ]
            save()
        }
    }

    var canAddMore: Bool {
        isPro || items.count < Store.freeLimit
    }

    func add(_ item: Job) {
        items.insert(item, at: 0)
        save()
    }

    func update(_ item: Job) {
        guard let idx = items.firstIndex(where: { $0.id == item.id }) else { return }
        items[idx] = item
        save()
    }

    func delete(at offsets: IndexSet) {
        items.remove(atOffsets: offsets)
        save()
    }

    func delete(_ item: Job) {
        items.removeAll { $0.id == item.id }
        save()
    }

    func load() {
        guard let data = try? Data(contentsOf: fileURL) else { return }
        if let decoded = try? JSONDecoder().decode([Job].self, from: data) {
            items = decoded
        }
    }

    func save() {
        guard let data = try? JSONEncoder().encode(items) else { return }
        try? data.write(to: fileURL, options: .atomic)
    }
}
