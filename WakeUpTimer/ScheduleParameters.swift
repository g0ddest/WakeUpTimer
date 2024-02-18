import Foundation

struct ScheduleParameters: Codable, Identifiable, Hashable {
    var id: UUID = .init()
    var selectedFrequency: String
    var selectedDays: Set<String>
    var selectedDate: Date
    var selectedTime: Date
    var isChecked: Bool = true

    public func toDateComponents(date _: Date) -> [DateComponents] {
        let calendar = Calendar.current
        var timeComponents = calendar.dateComponents([.hour, .minute], from: selectedTime)
        if selectedFrequency == "Daily" {
            return [timeComponents]
        } else if selectedFrequency == "Weekly" {
            if !selectedDays.isEmpty {
                return selectedDays.map { day in
                    ScheduleParameters.weekdayNum(name: day)
                }.filter { number in
                    number != nil
                }.map { number in
                    timeComponents = DateComponents(hour: timeComponents.hour, minute: timeComponents.minute, weekday: number)
                    return timeComponents
                }
            }
            return []
        } else {
            let dayComponents = calendar.dateComponents([.year, .month, .day], from: selectedDate)
            return [DateComponents(year: dayComponents.year, month: dayComponents.month, day: dayComponents.day, hour: timeComponents.hour, minute: timeComponents.minute)]
        }
    }

    private static func weekdayNum(name: String) -> Int? {
        switch name {
        case "Mo": return 2
        case "Tu": return 3
        case "We": return 4
        case "Th": return 5
        case "Fr": return 6
        case "Sa": return 7
        case "Su": return 1
        default: return nil
        }
    }
}
