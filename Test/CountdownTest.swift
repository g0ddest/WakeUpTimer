import XCTest

final class Test: XCTestCase {
    func date(time: String) -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm"
        return formatter.date(from: "2000/01/01 \(time)")!
    }

    func testShowing() throws {
        let countdown = Countdown.build(wakeupTime: "01:00", showBeforeHours: 1, date: date(time: "00:00"))

        XCTAssert(countdown.show == true)
        XCTAssert(countdown.text == "01:00")
    }

    func testShowingPM() throws {
        let countdown = Countdown.build(wakeupTime: "23:00", showBeforeHours: 1, date: date(time: "22:00"))

        XCTAssert(countdown.show == true)
        XCTAssert(countdown.text == "01:00")
    }

    func testShowingZeroHour() throws {
        let countdown = Countdown.build(wakeupTime: "00:00", showBeforeHours: 1, date: date(time: "23:00"))

        XCTAssert(countdown.show == true)
        XCTAssert(countdown.text == "01:00")
    }

    func testNotShowing() throws {
        let countdown = Countdown.build(wakeupTime: "00:00", showBeforeHours: 1, date: date(time: "22:59"))

        XCTAssert(countdown.show == false)
        XCTAssert(countdown.text == "01:01")
    }

    func testNotShowingRightAfter() throws {
        let countdown = Countdown.build(wakeupTime: "00:00", showBeforeHours: 1, date: date(time: "00:01"))

        XCTAssert(countdown.show == false)
        XCTAssert(countdown.text == "23:59")
    }
}
