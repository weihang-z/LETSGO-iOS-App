//
//  TravelLogDataStore.swift
//  LETSGO iOS App
//
//  Created by zft on 09/12/2025.
//

import UIKit

struct TravelLogEntry: Equatable {
    let id: UUID
    var title: String
    var location: String
    var city: String
    var startDate: Date
    var endDate: Date
    var summary: String
    var isPrivate: Bool
    var tags: [String]
    var coverImage: UIImage?
    var photos: [UIImage]
    var coverImageURL: String?
    var photoURLs: [String]
    
    var photoCount: Int {
        return photos.count
    }
    
    var year: Int {
        Calendar.current.component(.year, from: startDate)
    }
    
    var month: Int {
        Calendar.current.component(.month, from: startDate)
    }
    
    var monthYearKey: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: startDate)
    }
    
    static func == (lhs: TravelLogEntry, rhs: TravelLogEntry) -> Bool {
        return lhs.id == rhs.id
    }
    
    init(id: UUID = UUID(),
         title: String,
         location: String,
         city: String,
         startDate: Date,
         endDate: Date,
         summary: String,
         isPrivate: Bool,
         tags: [String],
         coverImage: UIImage? = nil,
         photos: [UIImage] = [],
         coverImageURL: String? = nil,
         photoURLs: [String] = []) {
        self.id = id
        self.title = title
        self.location = location
        self.city = city
        self.startDate = startDate
        self.endDate = endDate
        self.summary = summary
        self.isPrivate = isPrivate
        self.tags = tags
        self.coverImage = coverImage
        self.photos = photos
        self.coverImageURL = coverImageURL
        self.photoURLs = photoURLs
    }
}

final class TravelLogDataStore {
    static let shared = TravelLogDataStore()
    
    private(set) var logs: [TravelLogEntry] = []
    private let firebaseService = FirebaseService.shared
    
    var onLogsUpdated: (() -> Void)?
    
    private init() {
        if firebaseService.isLoggedIn {
            fetchLogsFromFirebase()
        } else {
            logs = TravelLogDataStore.sampleLogs
        }
    }
    
    
    func fetchLogsFromFirebase(completion: ((Bool) -> Void)? = nil) {
        guard let userId = firebaseService.currentUserId else {
            logs = TravelLogDataStore.sampleLogs
            completion?(false)
            return
        }
        
        firebaseService.fetchTravelLogs(for: userId) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let firebaseLogs):
                    self?.convertFirebaseLogsToLocal(firebaseLogs) { entries in
                        self?.logs = entries
                        self?.sortLogsByDate()
                        self?.onLogsUpdated?()
                        completion?(true)
                    }
                case .failure(let error):
                    print("Error fetching logs: \(error.localizedDescription)")
                    completion?(false)
                }
            }
        }
    }
    
    private func convertFirebaseLogsToLocal(_ firebaseLogs: [FirebaseTravelLog], completion: @escaping ([TravelLogEntry]) -> Void) {
        var entries: [TravelLogEntry] = []
        let group = DispatchGroup()
        
        for log in firebaseLogs {
            group.enter()
            
            var coverImage: UIImage?
            var photos: [UIImage] = []
            
            let innerGroup = DispatchGroup()
            
            if let coverURL = log.coverImageURL {
                innerGroup.enter()
                firebaseService.downloadImage(from: coverURL) { image in
                    coverImage = image
                    innerGroup.leave()
                }
            }
            
            for photoURL in log.photoURLs {
                innerGroup.enter()
                firebaseService.downloadImage(from: photoURL) { image in
                    if let image = image {
                        photos.append(image)
                    }
                    innerGroup.leave()
                }
            }
            
            innerGroup.notify(queue: .main) {
                let entry = TravelLogEntry(
                    id: UUID(uuidString: log.id) ?? UUID(),
                    title: log.title,
                    location: log.location,
                    city: log.city,
                    startDate: log.startDate,
                    endDate: log.endDate,
                    summary: log.summary,
                    isPrivate: log.isPrivate,
                    tags: log.tags,
                    coverImage: coverImage,
                    photos: photos,
                    coverImageURL: log.coverImageURL,
                    photoURLs: log.photoURLs
                )
                entries.append(entry)
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
            completion(entries)
        }
    }
    
    
    func add(_ entry: TravelLogEntry, completion: ((Bool) -> Void)? = nil) {
        logs.insert(entry, at: 0)
        sortLogsByDate()
        onLogsUpdated?()
        
        guard let userId = firebaseService.currentUserId else {
            completion?(false)
            return
        }
        
        firebaseService.uploadTravelLogWithImages(entry: entry, userId: userId) { result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self.fetchLogsFromFirebase { _ in
                        completion?(true)
                    }
                case .failure(let error):
                    print("Error saving log: \(error.localizedDescription)")
                    self.logs.removeAll { $0.id == entry.id }
                    self.onLogsUpdated?()
                    completion?(false)
                }
            }
        }
    }
    
    func update(_ entry: TravelLogEntry, completion: ((Bool) -> Void)? = nil) {
        let previousEntry = logs.first(where: { $0.id == entry.id })
        
        if let index = logs.firstIndex(where: { $0.id == entry.id }) {
            logs[index] = entry
            sortLogsByDate()
            onLogsUpdated?()
        }
        
        guard let userId = firebaseService.currentUserId else {
            completion?(false)
            return
        }
        
        firebaseService.uploadTravelLogWithImages(entry: entry, userId: userId) { result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self.fetchLogsFromFirebase { _ in
                        completion?(true)
                    }
                case .failure(let error):
                    print("Error updating log: \(error.localizedDescription)")
                    if let previousEntry = previousEntry,
                       let index = self.logs.firstIndex(where: { $0.id == previousEntry.id }) {
                        self.logs[index] = previousEntry
                        self.sortLogsByDate()
                        self.onLogsUpdated?()
                    }
                    completion?(false)
                }
            }
        }
    }
    
    func delete(_ entry: TravelLogEntry, completion: ((Bool) -> Void)? = nil) {
        logs.removeAll { $0.id == entry.id }
        onLogsUpdated?()
        
        firebaseService.deleteTravelLog(id: entry.id.uuidString) { result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    completion?(true)
                case .failure(let error):
                    print("Error deleting log: \(error.localizedDescription)")
                    completion?(false)
                }
            }
        }
    }
    
    func delete(at id: UUID, completion: ((Bool) -> Void)? = nil) {
        if let entry = logs.first(where: { $0.id == id }) {
            delete(entry, completion: completion)
        }
    }
    
    func getLog(by id: UUID) -> TravelLogEntry? {
        return logs.first { $0.id == id }
    }
    
    private func sortLogsByDate() {
        logs.sort { $0.startDate > $1.startDate }
    }
    
    
    func clearLocalData() {
        logs = []
        onLogsUpdated?()
    }
    
    func loadSampleData() {
        logs = TravelLogDataStore.sampleLogs
        onLogsUpdated?()
    }
    
    
    func logsGroupedByMonth() -> [(monthYear: String, logs: [TravelLogEntry])] {
        let grouped = Dictionary(grouping: logs) { $0.monthYearKey }
        let sortedKeys = grouped.keys.sorted { key1, key2 in
            guard let log1 = grouped[key1]?.first, let log2 = grouped[key2]?.first else {
                return false
            }
            return log1.startDate > log2.startDate
        }
        return sortedKeys.map { key in
            (monthYear: key, logs: grouped[key] ?? [])
        }
    }
    
    func filteredLogsGroupedByMonth(year: Int?, city: String?) -> [(monthYear: String, logs: [TravelLogEntry])] {
        let filtered = logs.filter { log in
            let matchesYear = year.map { $0 == log.year } ?? true
            let matchesCity = city.map { $0 == log.city } ?? true
            return matchesYear && matchesCity
        }
        
        let grouped = Dictionary(grouping: filtered) { $0.monthYearKey }
        let sortedKeys = grouped.keys.sorted { key1, key2 in
            guard let log1 = grouped[key1]?.first, let log2 = grouped[key2]?.first else {
                return false
            }
            return log1.startDate > log2.startDate
        }
        return sortedKeys.map { key in
            (monthYear: key, logs: grouped[key] ?? [])
        }
    }
    
    
    func search(query: String) -> [TravelLogEntry] {
        guard !query.isEmpty else { return logs }
        let lowercasedQuery = query.lowercased()
        return logs.filter { log in
            log.title.lowercased().contains(lowercasedQuery) ||
            log.location.lowercased().contains(lowercasedQuery) ||
            log.city.lowercased().contains(lowercasedQuery) ||
            log.summary.lowercased().contains(lowercasedQuery) ||
            log.tags.contains { $0.lowercased().contains(lowercasedQuery) }
        }
    }
    
    
    func getAllYears() -> [Int] {
        return Array(Set(logs.map { $0.year })).sorted(by: >)
    }
    
    func getAllCities() -> [String] {
        return Array(Set(logs.map { $0.city })).sorted()
    }
}

private extension TravelLogDataStore {
    static var sampleLogs: [TravelLogEntry] {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        return [
            TravelLogEntry(
                id: UUID(),
                title: "Trip to Eiffel Tower",
                location: "Paris, France",
                city: "Paris",
                startDate: formatter.date(from: "2024/11/10") ?? Date(),
                endDate: formatter.date(from: "2024/11/15") ?? Date(),
                summary: "An amazing trip to the iconic Eiffel Tower in Paris. The view from the top was breathtaking and the city lights at night were magical. We enjoyed delicious French cuisine and explored the charming streets of the city.",
                isPrivate: true,
                tags: ["travel", "paris", "adventure"]
            ),
            TravelLogEntry(
                id: UUID(),
                title: "Kyoto Autumn Sketchbook",
                location: "Kyoto, Japan",
                city: "Kyoto",
                startDate: formatter.date(from: "2024/10/18") ?? Date(),
                endDate: formatter.date(from: "2024/10/23") ?? Date(),
                summary: "Morning matcha runs, biking through Arashiyama bamboo, and painting temple rooftops in warm yellow tones.",
                isPrivate: false,
                tags: ["art", "asia", "fall"]
            ),
            TravelLogEntry(
                id: UUID(),
                title: "Desert Stargazing Retreat",
                location: "Shanghai, China",
                city: "Shanghai",
                startDate: formatter.date(from: "2024/05/05") ?? Date(),
                endDate: formatter.date(from: "2024/05/09") ?? Date(),
                summary: "Dawn hikes across quiet dunes, stargazing workshops, and late-night journaling beneath a glowing Milky Way.",
                isPrivate: true,
                tags: ["desert", "citywalk", "night"]
            ),
            TravelLogEntry(
                id: UUID(),
                title: "Winter Wonderland in Alps",
                location: "Zermatt, Switzerland",
                city: "Zermatt",
                startDate: formatter.date(from: "2023/12/20") ?? Date(),
                endDate: formatter.date(from: "2023/12/27") ?? Date(),
                summary: "Skiing down pristine slopes with the Matterhorn as backdrop. Hot chocolate by the fire and cozy alpine cabins.",
                isPrivate: false,
                tags: ["skiing", "winter", "mountains"]
            )
        ]
    }
}
