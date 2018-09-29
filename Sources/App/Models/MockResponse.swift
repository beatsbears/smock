//
//  MockResponse.swift
//  smock
//
//  Created by Andrew Scott on 9/26/18.
//
import FluentSQLite
import Codability
import Vapor

/// A single entry of a MockResponse.
final class MockResponse: SQLiteModel {
    /// The unique identifier for this `MockResponse`.
    var id: Int?

    /// url for mock response
    var route: String

    /// method for mock response
    var method: String

    /// payload for mock respose
    /// https://github.com/yonaskolb/Codability
    var payload: AnyCodable

    /// response code for mock respose
    var code: Int
    
    /// Any optional header pairs to return
    var headers: Dictionary<String, String>?

    /// Creates a new `MockResponse`.
    init(id: Int? = nil, route: String, method: Method, payload: AnyCodable, code: Int, headers: Dictionary<String, String>? = [:]) {
        self.id = id
        self.route = route
        self.method = method.rawValue
        self.payload = payload
        self.code = code
        self.headers = headers
    }
}

/// Allows `MockResponse` to be used as a dynamic migration.
extension MockResponse: Migration {}

/// Allows `MockResponse` to be encoded to and decoded from HTTP messages.
extension MockResponse: Content { }

/// Allows `MockResponse` to be used as a dynamic parameter in route definitions.
extension MockResponse: Parameter { }

/// supported HTTP verbs
enum Method: String {
    case GET
    case POST
    case PUT
    case DELETE
    case PATCH
}
