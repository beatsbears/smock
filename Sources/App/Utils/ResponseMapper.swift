//
//  ResponseMapper.swift
//  smock
//
//  Created by Andrew Scott on 9/26/18.
//

import Codability
import Foundation
import Vapor

class ResponseMapper {
    
    final let TEXT_HEADER = "Text"
    final let JSON_HEADER = "application/json"
    
    func payloadToData(payload: AnyCodable) throws -> Data {
        var responseData: Data
        let payloadType: PayloadTypes = self.payloadType(payload: payload)
        switch payloadType {
        case PayloadTypes.NUM:
            responseData = Data(bytes: payload.value as! UnsafeRawPointer, count: MemoryLayout.size(ofValue: payload.value))
        case PayloadTypes.TEXT:
            responseData = ((payload.value) as! String).data(using: .utf8)!
        case PayloadTypes.JSON:
            responseData = try JSONSerialization.data(withJSONObject: payload.value, options: [])
        case PayloadTypes.BOOL:
            responseData = ((payload.value as! Bool).description).data(using: .utf8)!
        default:
            throw Abort(.internalServerError)
        }
        return responseData
    }
    
    func mapToContentHeader(payload: AnyCodable) throws -> String {
        var responseHeader: String
        let payloadType: PayloadTypes = self.payloadType(payload: payload)
        switch payloadType {
        case .NUM, .BOOL, .TEXT:
            responseHeader = TEXT_HEADER
        case .JSON:
            responseHeader = JSON_HEADER
        default:
            responseHeader = TEXT_HEADER
        }
        return responseHeader
    }
    
    func payloadType(payload: AnyCodable) -> PayloadTypes {
        if let _ = payload.value as? String {
            return PayloadTypes.TEXT
        } else if let _ = payload.value as? Dictionary<AnyHashable, Any> {
            return PayloadTypes.JSON
        } else if let _ = payload.value as? Array<Any> {
            return PayloadTypes.JSON
        }else if var _ = payload.value as? Int {
            return PayloadTypes.NUM
        } else if let _ = payload.value as? Bool {
            // I notice that raw integers passed as a payload are mapped to Bool
            // This is clearly a bug, but also not a super likely use case.
            return PayloadTypes.BOOL
        } else {
            return PayloadTypes.OTHER
        }
    }
    
    public enum PayloadTypes: String {
        case TEXT
        case NUM
        case BOOL
        case JSON
        case OTHER
    }
}
