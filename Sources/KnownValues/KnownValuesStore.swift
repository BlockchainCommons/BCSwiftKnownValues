import Foundation

public struct KnownValuesStore: @unchecked Sendable {
    public private(set) var knownValuesByRawValue: [UInt64: KnownValue]
    public private(set) var knownValuesByAssignedName: [String: KnownValue]
    
    public init<T>(_ knownValues: T) where T: Sequence, T.Element == KnownValue {
        knownValuesByRawValue = [:]
        knownValuesByAssignedName = [:]
        for knownValue in knownValues {
            Self._insert(knownValue, knownValuesByRawValue: &knownValuesByRawValue, knownValuesByAssignedName: &knownValuesByAssignedName)
        }
    }
    
    @MainActor
    public mutating func insert(_ knownValue: KnownValue) {
        Self._insert(knownValue, knownValuesByRawValue: &knownValuesByRawValue, knownValuesByAssignedName: &knownValuesByAssignedName)
    }
    
    public func assignedName(for knownValue: KnownValue) -> String? {
        knownValuesByRawValue[knownValue.value]?.assignedName
    }
    
    public func name(for knownValue: KnownValue) -> String {
        assignedName(for: knownValue) ?? knownValue.name
    }
    
    public func knownValue(named assignedName: String) -> KnownValue? {
        knownValuesByAssignedName[assignedName]
    }
    
    public static func knownValue(for rawValue: UInt64, knownValues: KnownValuesStore? = nil) -> KnownValue {
        guard
            let knownValues,
            let namedKnownValue = knownValues.knownValuesByRawValue[rawValue]
        else {
            return KnownValue(rawValue)
        }
        return namedKnownValue
    }
    
    public static func knownValue(named assignedName: String, knownValues: KnownValuesStore? = nil) -> KnownValue? {
        guard
            let knownValues,
            let knownValue = knownValues.knownValuesByAssignedName[assignedName]
        else {
            return nil
        }
        return knownValue
    }
    
    public static func name(for knownValue: KnownValue, knownValues: KnownValuesStore? = nil) -> String {
        knownValues?.name(for: knownValue) ?? knownValue.name
    }

    static func _insert(_ knownValue: KnownValue, knownValuesByRawValue: inout [UInt64: KnownValue], knownValuesByAssignedName: inout [String: KnownValue]) {
        knownValuesByRawValue[knownValue.value] = knownValue
        if let name = knownValue.assignedName {
            knownValuesByAssignedName[name] = knownValue
        }
    }
}

// Conform to Sequence protocol to make KnownValuesStore iterable.
extension KnownValuesStore: Sequence {
    public func makeIterator() -> KnownValuesIterator {
        return KnownValuesIterator(knownValuesByRawValue: knownValuesByRawValue)
    }
}

// Iterator that iterates over known values in numeric order.
public struct KnownValuesIterator: IteratorProtocol {
    private var sortedKnownValues: [KnownValue]
    private var currentIndex: Int = 0
    
    init(knownValuesByRawValue: [UInt64: KnownValue]) {
        // Sort the known values by their numeric value.
        self.sortedKnownValues = knownValuesByRawValue.values.sorted(by: { $0.value < $1.value })
    }
    
    public mutating func next() -> KnownValue? {
        guard currentIndex < sortedKnownValues.count else { return nil }
        let knownValue = sortedKnownValues[currentIndex]
        currentIndex += 1
        return knownValue
    }
}

extension KnownValuesStore: ExpressibleByArrayLiteral {
    public init(arrayLiteral elements: KnownValue...) {
        self.init(elements)
    }
}
