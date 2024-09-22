import Testing
import KnownValues

struct KnownValuesTests {
    @Test func example() throws {
        for knownValue in globalKnownValues {
            print("\(knownValue.name) = \(knownValue.value)")
        }
    }
}
