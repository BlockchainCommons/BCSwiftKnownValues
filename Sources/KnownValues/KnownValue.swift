import Foundation
import URKit
import BCTags

/// A value representing an ontological concept.
///
/// Known Values are a standardized namespace of 64-bit unsigned integers that
/// represent ontological concepts, potentially across many vocabularies. This
/// standardization aims to enable compact binary representation, interoperability
/// across systems that exchange semantic information, and enhanced security by
/// mitigating the risks associated with URI manipulation.
public struct KnownValue {
    /// The known value as coded into CBOR.
    public let value: UInt64
    /// A name assigned to the known value used for debugging and formatted output.
    public let assignedName: String?
    
    /// Create a known value with the given unsigned integer value and name.
    public init(_ rawValue: UInt64, _ name: String? = nil) {
        self.value = rawValue
        self.assignedName = name
    }
    
    /// The human readable name.
    ///
    /// Defaults to the numerical value if no name has been assigned.
    public var name: String {
        return assignedName ?? String(value)
    }
}

extension KnownValue: Equatable {
    public static func ==(lhs: KnownValue, rhs: KnownValue) -> Bool {
        lhs.value == rhs.value
    }
}

extension KnownValue: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(value)
    }
}

extension KnownValue: CustomStringConvertible {
    public var description: String {
        assignedName ?? String(value)
    }
}

extension KnownValue: CBORTaggedCodable {
    public static let cborTags = [Tag.knownValue]
    
    public var untaggedCBOR: CBOR {
        .unsigned(value)
    }

    public init(untaggedCBOR: CBOR) throws {
        guard
            case CBOR.unsigned(let rawValue) = untaggedCBOR
        else {
            throw CBORError.invalidFormat
        }
        self = KnownValue(rawValue)
    }
}
