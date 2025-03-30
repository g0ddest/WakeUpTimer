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
    @Environment(\.openWindow)
    private var openWindow
    @State
    private var isSchedulerOpen = false

    init() {
        NSApplication.shared.setActivationPolicy(.accessory)
    }

    var body: some Scene {
        WindowGroup(id: "scheduler") {
            SchedulerView()
                .onAppear {
                    isSchedulerOpen = true
                }
                .onDisappear {
                    isSchedulerOpen = false
                }
        }

        MenuBarExtra(isInserted: $countdown.show) {
            Button("Settings") {
                if !isSchedulerOpen {
                    openWindow(id: "scheduler")
                    isSchedulerOpen = true
                } else {
                    NSApplication.shared.activate(ignoringOtherApps: true)
                }
            }
            Divider()
            Button("Quit") {
                NSApplication.shared.terminate(nil)
            }
        } label: {
            VStack {
                if countdown.text == "" {
                    Image(systemName: "moon.stars.circle")
                } else {
                    Image(nsImage: createStatusImage(text: countdown.text))
                }
            }.onReceive(timerSubscription) { _ in
                countdown = Countdown.build(
                    shedules: loadSchedules(),
                    showBefore: countdownStartString,
                    hideAfter: countdownEndString,
                    showAlways: showMenu == "always"
                )
            }
        }
    }

    private func loadSchedules() -> [ScheduleParameters] {
        if let decoded = try? JSONDecoder().decode([ScheduleParameters].self, from: schedulesData) {
            return decoded
        }
        return []
    }

    private func createStatusImage(text: String) -> NSImage {
        let size = NSSize(width: 45, height: 15)
        let image = NSImage(size: size)
        image.lockFocus()

        let backgroundColor = NSColor.red
        backgroundColor.setFill()
        NSBezierPath(roundedRect: NSRect(origin: .zero, size: size), xRadius: 6, yRadius: 6).fill()

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center

        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: NSColor.white,
            .font: NSFont.systemFont(ofSize: 12),
            .paragraphStyle: paragraphStyle
        ]

        let attributedString = NSAttributedString(string: text, attributes: attributes)
        attributedString.draw(in: NSRect(x: 0, y: 0, width: size.width, height: size.height))

        image.unlockFocus()
        return image
    }
}
