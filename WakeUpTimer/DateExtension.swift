import Foundation

public extension Date {
    private static var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter
    }

    static func from(time: String) -> Date {
        dateFormatter.date(from: time) ?? Date()
    }

    func toTime() -> String {
        Date.dateFormatter.string(from: self)
    }
}
