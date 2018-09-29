//
//  routes.swift
//  smock
//
//  Created by Andrew Scott on 9/26/18.
//
import Vapor

public func routes(_ router: Router) throws {
    let mockController = MockController()
    /// Mock management endpoints
    router.get("mocks", use: mockController.index)
    router.post("mocks", use: mockController.create)
    router.delete("mocks", use: mockController.delete)

    /// Mock response endpoints
    /// Vapor's all match will act as a catchall for requests that do not match
    /// any redefined routes. However, this approach precludes the use of regular
    /// route parameterization and parameter access in the handler and will allow any request
    /// so this approach is NOT recommended for production services.
    router.get(all, use: mockController.respond)
    router.post(all, use: mockController.respond)
    router.put(all, use: mockController.respond)
    router.delete(all, use: mockController.respond)
    router.patch(all, use: mockController.respond)
    /// If you wanted to define mocks for non-standard HTTP verbs you can do so
    /// ex. router.on(HTTPMethod.OPTIONS, all, use: mockController.respond)
    /// Note: be sure to add any new verbs to the Method enum in MockResponse.swift
}
