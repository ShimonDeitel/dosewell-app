import XCTest
@testable import Dosewell

final class DosewellTests: XCTestCase {
    var store: DosewellStore!

    override func setUp() {
        super.setUp()
        store = DosewellStore()
    }

    func testSeedDataIsBelowFreeLimit() {
        XCTAssertLessThan(store.doses.count, DosewellStore.freeTierLimit)
    }

    func testAddIncreasesCount() {
        let before = store.doses.count
        let added = store.add(MedicationDose(petName: "P", medicationName: "M", dose: "1"), isPro: false)
        XCTAssertTrue(added)
        XCTAssertEqual(store.doses.count, before + 1)
    }

    func testAddRespectsFreeLimitWhenNotPro() {
        while store.doses.count < DosewellStore.freeTierLimit {
            _ = store.add(MedicationDose(petName: "P", medicationName: "M", dose: "1"), isPro: false)
        }
        let blocked = store.add(MedicationDose(petName: "P", medicationName: "M", dose: "1"), isPro: false)
        XCTAssertFalse(blocked)
    }

    func testProBypassesFreeLimit() {
        while store.doses.count < DosewellStore.freeTierLimit {
            _ = store.add(MedicationDose(petName: "P", medicationName: "M", dose: "1"), isPro: false)
        }
        let allowed = store.add(MedicationDose(petName: "P", medicationName: "M", dose: "1"), isPro: true)
        XCTAssertTrue(allowed)
    }

    func testCanAddReflectsLimit() {
        while store.doses.count < DosewellStore.freeTierLimit {
            _ = store.add(MedicationDose(petName: "P", medicationName: "M", dose: "1"), isPro: false)
        }
        XCTAssertFalse(store.canAdd(isPro: false))
        XCTAssertTrue(store.canAdd(isPro: true))
    }

    func testRemoveDecreasesCount() {
        _ = store.add(MedicationDose(petName: "P", medicationName: "M", dose: "1"), isPro: false)
        let before = store.doses.count
        store.remove(at: IndexSet(integer: 0))
        XCTAssertEqual(store.doses.count, before - 1)
    }

    func testIsAtFreeLimitFalseInitially() {
        XCTAssertFalse(store.isAtFreeLimit)
    }

    func testPersistedStateRoundTrips() {
        let count = store.doses.count
        let reloaded = DosewellStore()
        XCTAssertEqual(reloaded.doses.count, count)
    }
}
