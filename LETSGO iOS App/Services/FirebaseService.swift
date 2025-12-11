//
//  FirebaseService.swift
//  LETSGO iOS App
//
//  Created by Weihang Zeng on 12/10/25.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

struct AppUser: Codable {
    let uid: String
    var email: String
    var username: String
    var bio: String?
    var avatarURL: String?
    var createdAt: Date
    
    init(uid: String, email: String, username: String) {
        self.uid = uid
        self.email = email
        self.username = username
        self.bio = "Ready for the next adventure!"
        self.avatarURL = nil
        self.createdAt = Date()
    }
    
    init?(document: DocumentSnapshot) {
        guard let data = document.data(),
              let uid = data["uid"] as? String,
              let email = data["email"] as? String,
              let username = data["username"] as? String else {
            return nil
        }
        self.uid = uid
        self.email = email
        self.username = username
        self.bio = data["bio"] as? String ?? "Ready for the next adventure!"
        self.avatarURL = data["avatarURL"] as? String
        self.createdAt = (data["createdAt"] as? Timestamp)?.dateValue() ?? Date()
    }
    
    var dictionary: [String: Any] {
        return [
            "uid": uid,
            "email": email,
            "username": username,
            "bio": bio as Any,
            "avatarURL": avatarURL as Any,
            "createdAt": Timestamp(date: createdAt)
        ]
    }
}

struct UserStats {
    var citiesVisited: Int
    var travelDays: Int
    var journalsCount: Int
    var visitedCities: [String]
    
    init(citiesVisited: Int = 0, travelDays: Int = 0, journalsCount: Int = 0, visitedCities: [String] = []) {
        self.citiesVisited = citiesVisited
        self.travelDays = travelDays
        self.journalsCount = journalsCount
        self.visitedCities = visitedCities
    }
    
    init() {
        citiesVisited = 0
        travelDays = 0
        journalsCount = 0
        visitedCities = []
    }
}

struct FirebaseTravelLog: Codable {
    let id: String
    let userId: String
    var title: String
    var location: String
    var city: String
    var startDate: Date
    var endDate: Date
    var summary: String
    var isPrivate: Bool
    var tags: [String]
    var coverImageURL: String?
    var photoURLs: [String]
    var createdAt: Date
    var updatedAt: Date
    
    init(from entry: TravelLogEntry, userId: String) {
        self.id = entry.id.uuidString
        self.userId = userId
        self.title = entry.title
        self.location = entry.location
        self.city = entry.city
        self.startDate = entry.startDate
        self.endDate = entry.endDate
        self.summary = entry.summary
        self.isPrivate = entry.isPrivate
        self.tags = entry.tags
        self.coverImageURL = nil
        self.photoURLs = []
        self.createdAt = Date()
        self.updatedAt = Date()
    }
    
    init?(document: DocumentSnapshot) {
        guard let data = document.data(),
              let id = data["id"] as? String,
              let userId = data["userId"] as? String,
              let title = data["title"] as? String,
              let location = data["location"] as? String,
              let city = data["city"] as? String,
              let startDate = (data["startDate"] as? Timestamp)?.dateValue(),
              let endDate = (data["endDate"] as? Timestamp)?.dateValue(),
              let summary = data["summary"] as? String else {
            return nil
        }
        
        self.id = id
        self.userId = userId
        self.title = title
        self.location = location
        self.city = city
        self.startDate = startDate
        self.endDate = endDate
        self.summary = summary
        self.isPrivate = data["isPrivate"] as? Bool ?? true
        self.tags = data["tags"] as? [String] ?? []
        self.coverImageURL = data["coverImageURL"] as? String
        self.photoURLs = data["photoURLs"] as? [String] ?? []
        self.createdAt = (data["createdAt"] as? Timestamp)?.dateValue() ?? Date()
        self.updatedAt = (data["updatedAt"] as? Timestamp)?.dateValue() ?? Date()
    }
    
    var dictionary: [String: Any] {
        return [
            "id": id,
            "userId": userId,
            "title": title,
            "location": location,
            "city": city,
            "startDate": Timestamp(date: startDate),
            "endDate": Timestamp(date: endDate),
            "summary": summary,
            "isPrivate": isPrivate,
            "tags": tags,
            "coverImageURL": coverImageURL as Any,
            "photoURLs": photoURLs,
            "createdAt": Timestamp(date: createdAt),
            "updatedAt": Timestamp(date: updatedAt)
        ]
    }
    
    func toTravelLogEntry(coverImage: UIImage?, photos: [UIImage]) -> TravelLogEntry {
        return TravelLogEntry(
            id: UUID(uuidString: id) ?? UUID(),
            title: title,
            location: location,
            city: city,
            startDate: startDate,
            endDate: endDate,
            summary: summary,
            isPrivate: isPrivate,
            tags: tags,
            coverImage: coverImage,
            photos: photos
        )
    }
}

final class FirebaseService {
    static let shared = FirebaseService()
    
    private let db = Firestore.firestore()
    private let storage = Storage.storage()
    private let auth = Auth.auth()
    
    private init() {}
    
    var currentUser: User? {
        return auth.currentUser
    }
    
    var isLoggedIn: Bool {
        return currentUser != nil
    }
    
    var currentUserId: String? {
        return currentUser?.uid
    }
    
    func addAuthStateListener(_ listener: @escaping (User?) -> Void) -> AuthStateDidChangeListenerHandle {
        return auth.addStateDidChangeListener { _, user in
            listener(user)
        }
    }
    
    func removeAuthStateListener(_ handle: AuthStateDidChangeListenerHandle) {
        auth.removeStateDidChangeListener(handle)
    }
    
    func signUp(email: String, password: String, username: String, completion: @escaping (Result<AppUser, Error>) -> Void) {
        auth.createUser(withEmail: email, password: password) { [weak self] result, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let user = result?.user else {
                completion(.failure(NSError(domain: "FirebaseService", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to create user"])))
                return
            }
            
            let appUser = AppUser(uid: user.uid, email: email, username: username)
            self?.createUserDocument(appUser, completion: completion)
        }
    }
    
    private func createUserDocument(_ user: AppUser, completion: @escaping (Result<AppUser, Error>) -> Void) {
        db.collection("users").document(user.uid).setData(user.dictionary) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(user))
            }
        }
    }
    
    func signIn(email: String, password: String, completion: @escaping (Result<User, Error>) -> Void) {
        auth.signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                completion(.failure(error))
            } else if let user = result?.user {
                completion(.success(user))
            } else {
                completion(.failure(NSError(domain: "FirebaseService", code: -1, userInfo: [NSLocalizedDescriptionKey: "Unknown error"])))
            }
        }
    }
    
    func signOut() throws {
        try auth.signOut()
    }
    
    func getUserProfile(uid: String, completion: @escaping (Result<AppUser, Error>) -> Void) {
        db.collection("users").document(uid).getDocument { snapshot, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let snapshot = snapshot, let user = AppUser(document: snapshot) else {
                completion(.failure(NSError(domain: "FirebaseService", code: -1, userInfo: [NSLocalizedDescriptionKey: "User not found"])))
                return
            }
            
            completion(.success(user))
        }
    }
    
    func getCurrentUserProfile(completion: @escaping (Result<AppUser, Error>) -> Void) {
        guard let uid = currentUserId else {
            completion(.failure(NSError(domain: "FirebaseService", code: -1, userInfo: [NSLocalizedDescriptionKey: "Not logged in"])))
            return
        }
        getUserProfile(uid: uid, completion: completion)
    }
    
    func updateUserProfile(_ user: AppUser, completion: @escaping (Result<Void, Error>) -> Void) {
        db.collection("users").document(user.uid).setData(user.dictionary, merge: true) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    
    func calculateUserStats(for userId: String, completion: @escaping (Result<UserStats, Error>) -> Void) {
        db.collection("travelLogs")
            .whereField("userId", isEqualTo: userId)
            .getDocuments { snapshot, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                let logs = snapshot?.documents.compactMap { FirebaseTravelLog(document: $0) } ?? []
                
                var stats = UserStats()
                stats.journalsCount = logs.count
                
                var uniqueCities = Set<String>()
                var totalTravelDays = 0
                
                for log in logs {
                    uniqueCities.insert(log.city)
                    
                    let calendar = Calendar.current
                    let components = calendar.dateComponents([.day], from: log.startDate, to: log.endDate)
                    let days = (components.day ?? 0) + 1
                    totalTravelDays += max(days, 1)
                }
                
                stats.citiesVisited = uniqueCities.count
                stats.travelDays = totalTravelDays
                stats.visitedCities = Array(uniqueCities).sorted()
                
                completion(.success(stats))
            }
    }
    
    func getUserProfileWithStats(uid: String, completion: @escaping (Result<(user: AppUser, stats: UserStats), Error>) -> Void) {
        let group = DispatchGroup()
        
        var fetchedUser: AppUser?
        var fetchedStats: UserStats?
        var fetchError: Error?
        
        group.enter()
        getUserProfile(uid: uid) { result in
            switch result {
            case .success(let user):
                fetchedUser = user
            case .failure(let error):
                fetchError = error
            }
            group.leave()
        }
        
        group.enter()
        calculateUserStats(for: uid) { result in
            switch result {
            case .success(let stats):
                fetchedStats = stats
            case .failure(let error):
                if fetchError == nil {
                    fetchError = error
                }
            }
            group.leave()
        }
        
        group.notify(queue: .main) {
            if let error = fetchError {
                completion(.failure(error))
                return
            }
            
            guard let user = fetchedUser else {
                completion(.failure(NSError(domain: "FirebaseService", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to fetch user"])))
                return
            }
            
            let stats = fetchedStats ?? UserStats()
            completion(.success((user: user, stats: stats)))
        }
    }
    
    func uploadImage(_ image: UIImage, path: String, completion: @escaping (Result<String, Error>) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.7) else {
            completion(.failure(NSError(domain: "FirebaseService", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to compress image"])))
            return
        }
        
        let storageRef = storage.reference().child(path)
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        storageRef.putData(imageData, metadata: metadata) { _, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            storageRef.downloadURL { url, error in
                if let error = error {
                    completion(.failure(error))
                } else if let url = url {
                    completion(.success(url.absoluteString))
                } else {
                    completion(.failure(NSError(domain: "FirebaseService", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to get download URL"])))
                }
            }
        }
    }
    
    func uploadAvatar(_ image: UIImage, for userId: String, completion: @escaping (Result<String, Error>) -> Void) {
        let path = "users/\(userId)/avatar.jpg"
        uploadImage(image, path: path, completion: completion)
    }
    
    func downloadImage(from urlString: String, completion: @escaping (UIImage?) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, _, _ in
            DispatchQueue.main.async {
                if let data = data, let image = UIImage(data: data) {
                    completion(image)
                } else {
                    completion(nil)
                }
            }
        }.resume()
    }
    
    
    func saveTravelLog(_ log: FirebaseTravelLog, completion: @escaping (Result<Void, Error>) -> Void) {
        db.collection("travelLogs").document(log.id).setData(log.dictionary) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    
    func fetchTravelLogs(for userId: String, completion: @escaping (Result<[FirebaseTravelLog], Error>) -> Void) {
        db.collection("travelLogs")
            .whereField("userId", isEqualTo: userId)
            .getDocuments { snapshot, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                let logs = snapshot?.documents.compactMap { FirebaseTravelLog(document: $0) } ?? []
                completion(.success(logs))
            }
    }
    
    func fetchFriendsTravelLogs(for userId: String, completion: @escaping (Result<[(log: FirebaseTravelLog, author: AppUser)], Error>) -> Void) {
        db.collection("users").document(userId).collection("friends").getDocuments { [weak self] snapshot, error in
            guard let self = self else { return }
            
            if let error = error {
                completion(.failure(error))
                return
            }
            
            let friendIds = snapshot?.documents.map { $0.documentID } ?? []
            
            guard !friendIds.isEmpty else {
                completion(.success([]))
                return
            }
            
            let group = DispatchGroup()
            var allLogs: [(log: FirebaseTravelLog, author: AppUser)] = []
            var friendProfiles: [String: AppUser] = [:]
            
            for friendId in friendIds {
                group.enter()
                self.getUserProfile(uid: friendId) { result in
                    if case .success(let user) = result {
                        friendProfiles[friendId] = user
                    }
                    group.leave()
                }
            }
            
            group.notify(queue: .main) {
                let logsGroup = DispatchGroup()
                
                for friendId in friendIds {
                    logsGroup.enter()
                    self.db.collection("travelLogs")
                        .whereField("userId", isEqualTo: friendId)
                        .getDocuments { snapshot, error in
                            defer { logsGroup.leave() }
                            
                            if let error = error {
                                print("Error fetching logs for friend \(friendId): \(error.localizedDescription)")
                                return
                            }
                            
                            guard let documents = snapshot?.documents else { return }
                            
                            let logs = documents
                                .compactMap { FirebaseTravelLog(document: $0) }
                                .filter { $0.isPrivate == false }
                                .sorted { $0.startDate > $1.startDate }
                                .prefix(10)
                            
                            for log in logs {
                                if let author = friendProfiles[friendId] {
                                    allLogs.append((log: log, author: author))
                                }
                            }
                        }
                }
                
                logsGroup.notify(queue: .main) {
                    let sortedLogs = allLogs.sorted { $0.log.startDate > $1.log.startDate }
                    completion(.success(sortedLogs))
                }
            }
        }
    }
    
    func deleteTravelLog(id: String, completion: @escaping (Result<Void, Error>) -> Void) {
        db.collection("travelLogs").document(id).delete { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    
    func uploadTravelLogWithImages(entry: TravelLogEntry, userId: String, completion: @escaping (Result<Void, Error>) -> Void) {
        var firebaseLog = FirebaseTravelLog(from: entry, userId: userId)
        let group = DispatchGroup()
        var uploadErrors: [Error] = []
        
        if let coverImage = entry.coverImage {
            group.enter()
            let coverPath = "travelLogs/\(userId)/\(entry.id.uuidString)/cover.jpg"
            uploadImage(coverImage, path: coverPath) { result in
                switch result {
                case .success(let url):
                    firebaseLog.coverImageURL = url
                case .failure(let error):
                    uploadErrors.append(error)
                }
                group.leave()
            }
        }
        
        for (index, photo) in entry.photos.enumerated() {
            group.enter()
            let photoPath = "travelLogs/\(userId)/\(entry.id.uuidString)/photo_\(index).jpg"
            uploadImage(photo, path: photoPath) { result in
                switch result {
                case .success(let url):
                    firebaseLog.photoURLs.append(url)
                case .failure(let error):
                    uploadErrors.append(error)
                }
                group.leave()
            }
        }
        
        group.notify(queue: .main) { [weak self] in
            let hadUploadErrors = !uploadErrors.isEmpty
            
            self?.saveTravelLog(firebaseLog) { result in
                switch result {
                case .success:
                    if hadUploadErrors {
                    }
                    completion(.success(()))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
    
    
    func addFriend(currentUserId: String, friendId: String, completion: @escaping (Result<Void, Error>) -> Void) {
        let batch = db.batch()
        
        let currentUserFriendRef = db.collection("users").document(currentUserId).collection("friends").document(friendId)
        batch.setData(["addedAt": Timestamp()], forDocument: currentUserFriendRef)
        
        let friendRef = db.collection("users").document(friendId).collection("friends").document(currentUserId)
        batch.setData(["addedAt": Timestamp()], forDocument: friendRef)
        
        batch.commit { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    
    func fetchFriends(for userId: String, completion: @escaping (Result<[AppUser], Error>) -> Void) {
        db.collection("users").document(userId).collection("friends").getDocuments { [weak self] snapshot, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            let friendIds = snapshot?.documents.map { $0.documentID } ?? []
            
            guard !friendIds.isEmpty else {
                completion(.success([]))
                return
            }
            
            let group = DispatchGroup()
            var friends: [AppUser] = []
            
            for friendId in friendIds {
                group.enter()
                self?.getUserProfile(uid: friendId) { result in
                    if case .success(let user) = result {
                        friends.append(user)
                    }
                    group.leave()
                }
            }
            
            group.notify(queue: .main) {
                completion(.success(friends))
            }
        }
    }
    
    func removeFriend(currentUserId: String, friendId: String, completion: @escaping (Result<Void, Error>) -> Void) {
        let batch = db.batch()
        
        let currentUserFriendRef = db.collection("users").document(currentUserId).collection("friends").document(friendId)
        batch.deleteDocument(currentUserFriendRef)
        
        let friendRef = db.collection("users").document(friendId).collection("friends").document(currentUserId)
        batch.deleteDocument(friendRef)
        
        batch.commit { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    
    func getFriendsCount(for userId: String, completion: @escaping (Result<Int, Error>) -> Void) {
        db.collection("users").document(userId).collection("friends").getDocuments { snapshot, error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(snapshot?.documents.count ?? 0))
            }
        }
    }
    
    func searchUsers(query: String, completion: @escaping (Result<[AppUser], Error>) -> Void) {
        db.collection("users")
            .whereField("username", isGreaterThanOrEqualTo: query)
            .whereField("username", isLessThanOrEqualTo: query + "\u{f8ff}")
            .limit(to: 20)
            .getDocuments { snapshot, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                let users = snapshot?.documents.compactMap { AppUser(document: $0) } ?? []
                completion(.success(users))
            }
    }
    
    func searchUsersByUsernameOrEmail(query: String, completion: @escaping (Result<[AppUser], Error>) -> Void) {
        let lowercaseQuery = query.lowercased()
        
        let isEmail = lowercaseQuery.contains("@")
        
        if isEmail {
            db.collection("users")
                .whereField("email", isEqualTo: lowercaseQuery)
                .limit(to: 10)
                .getDocuments { snapshot, error in
                    if let error = error {
                        completion(.failure(error))
                        return
                    }
                    
                    let users = snapshot?.documents.compactMap { AppUser(document: $0) } ?? []
                    completion(.success(users))
                }
        } else {
            db.collection("users")
                .whereField("username", isGreaterThanOrEqualTo: query)
                .whereField("username", isLessThanOrEqualTo: query + "\u{f8ff}")
                .limit(to: 20)
                .getDocuments { snapshot, error in
                    if let error = error {
                        completion(.failure(error))
                        return
                    }
                    
                    let users = snapshot?.documents.compactMap { AppUser(document: $0) } ?? []
                    completion(.success(users))
                }
        }
    }
}
