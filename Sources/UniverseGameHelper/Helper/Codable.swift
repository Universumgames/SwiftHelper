//
//  Codable.swift
//  Moody
//
//  Created by Tom Arlt on 20.01.22.
//

import Foundation

public var DefaultJSONDecoder: JSONDecoder {
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .iso8601WithFractionalSeconds
    return decoder
}

public var DefaultJSONEncoder: JSONEncoder{
    let encoder = JSONEncoder()
    encoder.outputFormatting = [.prettyPrinted]
    encoder.dateEncodingStrategy = .iso8601WithFractionalSeconds
    return encoder
}

public extension Encodable {
    func toData() -> Data? {
        return try? DefaultJSONEncoder.encode(self)
    }
}

@propertyWrapper
public struct CodableIgnored<T>: Codable {
    public var wrappedValue: T?
        
    public init(wrappedValue: T?) {
        self.wrappedValue = wrappedValue
    }
    
    public init(from decoder: Decoder) throws {
        self.wrappedValue = nil
    }
    
    public func encode(to encoder: Encoder) throws {
        // Do nothing
    }
}

public extension KeyedDecodingContainer {
    public func decode<T>(
        _ type: CodableIgnored<T>.Type,
        forKey key: Self.Key) throws -> CodableIgnored<T>
    {
        return CodableIgnored(wrappedValue: nil)
    }
}

public extension KeyedEncodingContainer {
    public mutating func encode<T>(
        _ value: CodableIgnored<T>,
        forKey key: KeyedEncodingContainer<K>.Key) throws
    {
        // Do nothing
    }
}
