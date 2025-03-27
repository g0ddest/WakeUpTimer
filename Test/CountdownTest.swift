import XCTest

final class CountdownTest: XCTestCase {
    func date(time: String) -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm"
        return formatter.date(from: "2000/01/01 \(time)")!
    }

    func testShowingDaily() throws {
        let countdown = Countdown.build(shedules: [
            ScheduleParameters(selectedFrequency: "Daily", selectedDays: Set(), selectedDate: Date(), selectedTime: date(time: "06:00"))
        ], showBefore: "08:00", hideAfter: "03:00", date: date(time: "23:00"), showAlways: false)

        XCTAssert(countdown.show == true)
        XCTAssert(countdown.text == "07:00")
    }

    func testNotShowingDailyTooSoon() throws {
        let countdown = Countdown.build(shedules: [
            ScheduleParameters(selectedFrequency: "Daily", selectedDays: Set(), selectedDate: Date(), selectedTime: date(time: "06:00"))
        ], showBefore: "08:00", hideAfter: "03:00", date: date(time: "05:00"), showAlways: false)

        XCTAssert(countdown.show == false)
        XCTAssert(countdown.text == "")
    }

    func testNotShowingDailyTooEarly() throws {
        let countdown = Countdown.build(shedules: [
            ScheduleParameters(selectedFrequency: "Daily", selectedDays: Set(), selectedDate: Date(), selectedTime: date(time: "06:00"))
        ], showBefore: "08:00", hideAfter: "03:00", date: date(time: "12:00"), showAlways: false)

        XCTAssert(countdown.show == false)
        XCTAssert(countdown.text == "")
    }

    func testShowingWeekly() throws {
        let countdown = Countdown.build(shedules: [
            ScheduleParameters(selectedFrequency: "Weekly", selectedDays: ["Su"], selectedDate: Date(), selectedTime: date(time: "06:00"))
        ], showBefore: "08:00", hideAfter: "03:00", date: date(time: "23:00"), showAlways: false)

        XCTAssert(countdown.show == true)
        XCTAssert(countdown.text == "07:00")
    }

    func testNotShowingWeekly() throws {
        let countdown = Countdown.build(shedules: [
            ScheduleParameters(selectedFrequency: "Weekly", selectedDays: ["Mo"], selectedDate: Date(), selectedTime: date(time: "06:00"))
        ], showBefore: "08:00", hideAfter: "03:00", date: date(time: "23:00"), showAlways: false)

        XCTAssert(countdown.show == false)
        XCTAssert(countdown.text == "")
    }

    func testShowingSpecificDay() throws {
        let countdown = Countdown.build(shedules: [
            ScheduleParameters(selectedFrequency: "Once", selectedDays: Set(), selectedDate: date(time: "08:00"), selectedTime: date(time: "08:00"))
        ], showBefore: "08:00", hideAfter: "03:00", date: date(time: "03:00"), showAlways: false)

        XCTAssert(countdown.show == true)
        XCTAssert(countdown.text == "05:00")
    }

    func testNotShowingSpecificDay() throws {
        let countdown = Countdown.build(shedules: [
            ScheduleParameters(selectedFrequency: "Once", selectedDays: Set(), selectedDate: date(time: "08:00"), selectedTime: date(time: "08:00"))
        ], showBefore: "08:00", hideAfter: "03:00", date: date(time: "07:00"), showAlways: false)

        XCTAssert(countdown.show == false)
        XCTAssert(countdown.text == "")
    }

    func testShowingCombination() throws {
        let countdown = Countdown.build(shedules: [
            ScheduleParameters(selectedFrequency: "Once", selectedDays: Set(), selectedDate: date(time: "08:00"), selectedTime: date(time: "08:00")),
            ScheduleParameters(selectedFrequency: "Weekly", selectedDays: ["Su"], selectedDate: Date(), selectedTime: date(time: "06:00"))
        ], showBefore: "08:00", hideAfter: "03:00", date: date(time: "23:00"), showAlways: false)

        XCTAssert(countdown.show == true)
        XCTAssert(countdown.text == "07:00")
    }
}
