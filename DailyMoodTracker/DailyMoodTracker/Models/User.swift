//
//  User.swift
//  DailyMoodTracker
//
//  Created by etudiant on 10/12/2024.
//

import Foundation
import SwiftData

@Model
class User: Identifiable, Codable {
    @Attribute(.unique) var id: UUID
    var username: String
    var email: String
    var password: String
    var dateCreated: Date

    // MARK: - Constructeur par défaut
    init(id: UUID = UUID(), username: String, email: String, password: String, dateCreated: Date = Date()) {
        self.id = id
        self.username = username
        self.email = email
        self.password = password
        self.dateCreated = dateCreated
    }
    
    // MARK: - Constructeur par Objet
    init(from user: User) {
        self.id = user.id
        self.username = user.username
        self.email = user.email
        self.password = user.password
        self.dateCreated = user.dateCreated
    }
    
    // MARK: - Encodable
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(username, forKey: .username)
        try container.encode(email, forKey: .email)
        try container.encode(password, forKey: .password)
        try container.encode(dateCreated, forKey: .dateCreated)
    }
    
    // MARK: - Decodable
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(UUID.self, forKey: .id)
        self.username = try container.decode(String.self, forKey: .username)
        self.email = try container.decode(String.self, forKey: .email)
        self.password = try container.decode(String.self, forKey: .password)
        self.dateCreated = try container.decode(Date.self, forKey: .dateCreated)
    }
    
    // MARK: - CodingKeys
    private enum CodingKeys: String, CodingKey {
        case id, username, email, password, dateCreated
    }
}
