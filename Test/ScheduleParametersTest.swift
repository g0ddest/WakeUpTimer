import XCTest

final class ScheduleParametersTest: XCTestCase {
    func date(time: String) -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm"
        return formatter.date(from: "2000/01/01 \(time)")!
    }

    func testNextWeekDay() throws {
        let dateSelecteed = date(time: "01:23")
        let components = ScheduleParameters(
            selectedFrequency: "Weekly",
            selectedDays: ["Mo", "Fr"],
            selectedDate: dateSelecteed,
            selectedTime: dateSelecteed,
            isChecked: true
        ).toDateComponents(date: dateSelecteed)

        XCTAssert(components.count == 2)
        XCTAssert(components[0].hour == 1)
        XCTAssert(components[0].minute == 23)
        XCTAssert(components[0].weekday == 2 || components[0].weekday == 6)
        XCTAssert(components[1].hour == 1)
        XCTAssert(components[1].minute == 23)
        XCTAssert(components[1].weekday == 2 || components[1].weekday == 6)
    }

    func testOnce() throws {
        let dateSelecteed = date(time: "01:23")
        let components = ScheduleParameters(
            selectedFrequency: "Once",
            selectedDays: [],
            selectedDate: dateSelecteed,
            selectedTime: dateSelecteed,
            isChecked: true
        ).toDateComponents(date: dateSelecteed)

        XCTAssert(components.count == 1)
        XCTAssert(components[0].hour == 1)
        XCTAssert(components[0].minute == 23)
        XCTAssert(components[0].day == 1)
        XCTAssert(components[0].month == 1)
    }

    func testDaily() throws {
        let dateSelecteed = date(time: "02:23")
        let components = ScheduleParameters(
            selectedFrequency: "Daily",
            selectedDays: [],
            selectedDate: dateSelecteed,
            selectedTime: dateSelecteed,
            isChecked: true
        ).toDateComponents(date: dateSelecteed)

        XCTAssert(components.count == 1)
        XCTAssert(components[0].hour == 2)
        XCTAssert(components[0].minute == 23)
    }
}
