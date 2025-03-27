import SwiftUI

// MARK: - SchedulerView

struct SchedulerView: View {
    @AppStorage("countdownStart")
    private var countdownStartString: String = "08:00"
    @AppStorage("countdownEnd")
    private var countdownEndString: String = "03:00"
    @AppStorage("showMenu")
    private var showMenu: String = "always"
    @AppStorage("schedules")
    private var schedulesData: Data = .init()

    private var countdownStart: Binding<Date> {
        Binding<Date>(
            get: {
                Date.from(time: countdownStartString)
            },
            set: {
                countdownStartString = $0.toTime()
            }
        )
    }

    private var countdownEnd: Binding<Date> {
        Binding<Date>(
            get: {
                Date.from(time: countdownEndString)
            },
            set: {
                countdownEndString = $0.toTime()
            }
        )
    }

    @State
    private var schedules: [ScheduleParameters] = []

    var body: some View {
        VStack(alignment: .leading) {
            List {
                ForEach(schedules.indices, id: \.self) { index in
                    ScheduleRow(parameters: Binding(
                        get: { schedules[index] },
                        set: {
                            schedules[index] = $0
                            saveSchedules()
                        }
                    ))
                    .contextMenu {
                        Button("Duplicate") {
                            duplicateSchedule(at: index)
                        }
                        Button("Delete", role: .destructive) {
                            withAnimation {
                                deleteSchedule(at: IndexSet(integer: index))
                            }
                        }
                    }
                }
                Button(action: {
                    let newSchedule = ScheduleParameters(selectedFrequency: "Once", selectedDays: [], selectedDate: Date(), selectedTime: Date(), isChecked: true)
                    schedules.append(newSchedule)
                    saveSchedules()
                }) {
                    Image(systemName: "plus")
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)

            VStack(alignment: .leading, spacing: 20) {
                // Start Countdown Section
                HStack {
                    Text("Start countdown")
                    DatePicker("", selection: countdownStart, displayedComponents: .hourAndMinute)
                        .labelsHidden()
                    Text("and stop")
                    DatePicker("", selection: countdownEnd, displayedComponents: .hourAndMinute)
                        .labelsHidden()
                    Text("before wake up")
                }

                // Show Menu Item Section
                Picker(selection: $showMenu, label: Text("Show Menu Item")) {
                    Text("Always").tag("always")
                    Text("When counting down (Re-launch for Settings)").tag("counting")
                }
                .pickerStyle(.radioGroup)

            }.padding()
        }.onAppear {
            loadSchedules()
        }.frame(minWidth: 500)
    }

    private func loadSchedules() {
        if let decoded = try? JSONDecoder().decode([ScheduleParameters].self, from: schedulesData) {
            schedules = decoded
        }
    }

    private func saveSchedules() {
        if let encoded = try? JSONEncoder().encode(schedules) {
            schedulesData = encoded
        }
    }

    private func duplicateSchedule(at index: Int) {
        let scheduleToDuplicate = schedules[index]
        schedules.append(scheduleToDuplicate)
        saveSchedules()
    }

    private func deleteSchedule(at offsets: IndexSet) {
        schedules.remove(atOffsets: offsets)
        saveSchedules()
    }
}

// MARK: - SchedulerView_Previews

struct SchedulerView_Previews: PreviewProvider {
    static var previews: some View {
        SchedulerView()
    }
}
