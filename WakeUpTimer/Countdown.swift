import Foundation

struct Countdown {
    var text: String
    var seconds: Int
    var show: Bool

    static func build(shedules: [ScheduleParameters], showBefore: String, hideAfter: String, showAlways: Bool) -> Countdown {
        build(shedules: shedules, showBefore: showBefore, hideAfter: hideAfter, date: Date(), showAlways: showAlways)
    }

    static func build(shedules: [ScheduleParameters], showBefore: String, hideAfter: String, date: Date, showAlways: Bool) -> Countdown {
        shedules.flatMap { shedule in
            build(shedule: shedule, showBefore: showBefore, hideAfter: hideAfter, date: date, showAlways: showAlways)
        }.filter { countdown in
            countdown.show
        }
        .min(by: { $0.seconds < $1.seconds }) ?? Countdown(text: "", seconds: 0, show: showAlways)
    }

    static func build(shedule: ScheduleParameters, showBefore: String, hideAfter: String, date: Date, showAlways: Bool) -> [Countdown] {
        if !shedule.isChecked {
            return []
        }

        let calendar = Calendar.current

        return shedule.toDateComponents(date: date)
            .map { component in
                calendar.nextDate(after: date, matching: component, matchingPolicy: .nextTime)
            }
            .filter { nextDate in nextDate != nil }
            .map { nextDate in
                calendar.dateComponents([.second], from: date, to: nextDate!).second
            }
            .filter { remainingSeconds in remainingSeconds != nil }
            .map { remainingSeconds in
                let seconds = remainingSeconds!
                let hours = seconds / 3_600
                let minutes = (seconds % 3_600) / 60

                return Countdown(
                    text: seconds <= timeToSeconds(time: showBefore)! && seconds >= timeToSeconds(time: hideAfter)! ? String(format: "%02d:%02d", hours, minutes) : "",
                    seconds: seconds,
                    show: showAlways || (seconds <= timeToSeconds(time: showBefore)! && seconds >= timeToSeconds(time: hideAfter)!)
                )
            }
    }

    private static func timeToSeconds(time: String) -> Int? {
        let timeComponents = time.split(separator: ":")
        guard timeComponents.count == 2,
              let hour = Int(timeComponents[0]),
              let minute = Int(timeComponents[1])
        else {
            return nil
        }
        return hour * 3_600 + minute * 60
    }
}
