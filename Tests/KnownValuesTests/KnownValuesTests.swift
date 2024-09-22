import Testing
import KnownValues

struct KnownValuesTests {
    @Test @MainActor func addKnownValue() throws {
        let knownValue = KnownValue(12345, "testValue")
        globalKnownValues.insert(knownValue)
    }
    
    @Test func enumerateKnownValues() {
        for knownValue in globalKnownValues {
            print("\(knownValue.name) = \(knownValue.value)")
        }
    }
}
