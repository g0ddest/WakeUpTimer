import SwiftUI

@main
struct StatusBarApp: App {
    @AppStorage("wakeup.at")
    var wakeupTime: String = "06:00"
    @AppStorage("show.before")
    var showBeforeHours: Int = 9

    private var timerSubscription = Timer.publish(every: 1, on: .main, in: .common)
        .autoconnect()

    @State
    var countdown = Countdown(text: "", show: false)

    var body: some Scene {
        MenuBarExtra(isInserted: $countdown.show) {
            Button("Quit") {
                NSApplication.shared.terminate(nil)
            }.keyboardShortcut("q")
        } label: {
            VStack {
                Image(systemName: "moon.stars.circle")
                Text(countdown.text)
            }.onReceive(timerSubscription) { _ in
                countdown = Countdown.build(wakeupTime: wakeupTime, showBeforeHours: showBeforeHours)
            }
        }
    }
}
