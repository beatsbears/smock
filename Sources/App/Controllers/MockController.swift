//
//  MockController.swift
//  smock
//
//  Created by Andrew Scott on 9/26/18.
//
import Vapor
import Fluent

final class MockController {
    func index(_ req: Request) throws -> Future<[MockResponse]> {
        return MockResponse.query(on: req).all()
    }

    func create(_ req: Request) throws -> Future<MockResponse> {
        return try req.content.decode(MockResponse.self).flatMap { mock in
            return mock.save(on: req)
        }
    }

    func delete(_ req: Request) throws -> Future<HTTPStatus> {
        return try req.parameters.next(MockResponse.self).flatMap { mock in
            return mock.delete(on: req)
        }.transform(to: .ok)
    }

    func lookup(_ req: Request) throws -> Future<MockResponse> {
        // Since we cannot use req.parameters.next() to access string params when "all" is used
        // this will fall back to getting the unparsed url from the request and dropping the preceeding "/"
        let route: String = String(req.http.url.absoluteString.dropFirst())
        let method: String = req.http.method.string
        return MockResponse.query(on: req).filter(\.route == route).filter(\.method == method).first().unwrap(or: Abort(.notFound))
    }
    
    func respond(_ req: Request) throws -> Future<HTTPResponse> {
        let rm = ResponseMapper()
        do {
            return try self.lookup(req).map(to: HTTPResponse.self) { mock in
                // Add headers
                var headers = HTTPHeaders()
                headers.add(name: "Content-Type", value: try rm.mapToContentHeader(payload: mock.payload))
                if mock.headers != nil {
                    for header in mock.headers! {
                            headers.add(name: header.key, value: header.value)
                    }
                }

                // Add body
                let payloadData: Data = try rm.payloadToData(payload: mock.payload)
                let body = HTTPBody(data: payloadData as Data)
                
                // craft custom response
                return HTTPResponse(status: HTTPResponseStatus.init(statusCode: mock.code),
                                    version: HTTPVersion.init(major: 1, minor: 1),
                                    headers: headers,
                                    body: body
                )
            }
        } catch {
            /// Throw a 404 if lookup fails OR if the any of the mappings fail
            /// Note: Test error responses should be created like any other mock in
            /// order to allow flexibility in the response attributes.
            throw Abort(.notFound)
        }
    }
}
