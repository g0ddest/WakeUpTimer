import SwiftUI

@main
struct StatusBarApp: App {
    @AppStorage("countdownStart")
    private var countdownStartString: String = "08:00"
    @AppStorage("countdownEnd")
    private var countdownEndString: String = "03:00"
    @AppStorage("showMenu")
    private var showMenu: String = "always"
    @AppStorage("schedules")
    private var schedulesData: Data = .init()

    private var timerSubscription = Timer.publish(every: 1, on: .main, in: .common)
        .autoconnect()

    @State
    var countdown = Countdown(text: "", seconds: 0, show: false)

    var body: some Scene {
        WindowGroup {
            SchedulerView()
        }

        MenuBarExtra(isInserted: $countdown.show) {
            Button("Quit") {
                NSApplication.shared.terminate(nil)
            }.keyboardShortcut("q")
        } label: {
            VStack {
                Image(systemName: "moon.stars.circle")
                Text(countdown.text)
            }.onReceive(timerSubscription) { _ in
                countdown = Countdown.build(shedules: loadSchedules(), showBefore: countdownStartString, hideAfter: countdownEndString)
            }
        }
    }

    private func loadSchedules() -> [ScheduleParameters] {
        if let decoded = try? JSONDecoder().decode([ScheduleParameters].self, from: schedulesData) {
            return decoded
        }
        return []
    }
}
