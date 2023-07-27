import Foundation

struct Countdown {
    var text: String
    var show: Bool

    static func build(wakeupTime: String, showBeforeHours: Int) -> Countdown {
        Countdown.build(wakeupTime: wakeupTime, showBeforeHours: showBeforeHours, date: Date())
    }

    static func build(wakeupTime: String, showBeforeHours: Int, date: Date) -> Countdown {
        let calendar = Calendar.current

        let wakeupComponents = wakeupTime.split(separator: ":")
        guard wakeupComponents.count == 2,
              let wakeupHour = Int(wakeupComponents[0]),
              let wakeupMinute = Int(wakeupComponents[1])
        else {
            return Countdown(text: "Error", show: false)
        }

        var dateComponents = DateComponents()
        dateComponents.hour = wakeupHour
        dateComponents.minute = wakeupMinute
        let nextWakeupTime = calendar.nextDate(after: date, matching: dateComponents, matchingPolicy: .nextTime)!
        let remainingSeconds = calendar.dateComponents([.second], from: date, to: nextWakeupTime).second!

        let hours = remainingSeconds / 3_600
        let minutes = (remainingSeconds % 3_600) / 60

        return Countdown(
            text: String(format: "%02d:%02d", hours, minutes),
            show: remainingSeconds <= (showBeforeHours * 3_600)
        )
    }
}
