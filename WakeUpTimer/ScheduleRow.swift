import SwiftUI

// MARK: - ScheduleRow

struct ScheduleRow: View {
    @Binding
    var parameters: ScheduleParameters

    init(parameters: Binding<ScheduleParameters>) {
        _parameters = parameters
    }

    let daysOfWeek = ["Mo", "Tu", "We", "Th", "Fr", "Sa", "Su"]

    var body: some View {
        HStack {
            // Frequency Picker
            Picker(selection: $parameters.selectedFrequency, label: EmptyView()) {
                Text("Daily").tag("Daily")
                Text("Weekly").tag("Weekly")
                Text("Once").tag("Once")
            }
            .pickerStyle(MenuPickerStyle())
            .frame(width: 100)
            .labelsHidden()
            .onChange(of: parameters.selectedFrequency, perform: { _ in
                parameters.selectedDays = []
            })

            // Day of the week Picker (for Weekly)
            if parameters.selectedFrequency == "Weekly" {
                Text("on")
                ForEach(daysOfWeek, id: \.self) { day in
                    DayButton(day: day, isSelected: parameters.selectedDays.contains(day)) {
                        if parameters.selectedDays.contains(day) {
                            parameters.selectedDays.remove(day)
                        } else {
                            parameters.selectedDays.insert(day)
                        }
                    }
                }
            }

            // Date Picker (for Once)
            if parameters.selectedFrequency == "Once" {
                Text("on")
                DatePicker("", selection: $parameters.selectedDate, displayedComponents: .date)
                    .datePickerStyle(DefaultDatePickerStyle())
                    .frame(width: 90)
            }

            Text("at")
                .frame(width: 20)
                .frame(alignment: .leading)

            DatePicker("", selection: $parameters.selectedTime, displayedComponents: .hourAndMinute)
                .labelsHidden()
                .frame(width: 45)

            Spacer()

            Toggle("", isOn: $parameters.isChecked)
        }.frame(maxWidth: .infinity, alignment: .leading)
    }
}

// MARK: - DayButton

struct DayButton: View {
    let day: String
    var isSelected: Bool
    let action: () -> Void

    var body: some View {
        Text(day)
            .foregroundColor(isSelected ? .white : .primary)
            .padding(EdgeInsets(top: 3, leading: 3, bottom: 3, trailing: 3))
            .background(isSelected ? Color.blue : Color.gray.opacity(0.2))
            .cornerRadius(5)
            .overlay(
                RoundedRectangle(cornerRadius: 5)
                    .stroke(Color.gray.opacity(0.2), lineWidth: 1)
            )
            .onTapGesture(perform: action)
    }
}

// MARK: - ScheduleRow_Previews

struct ScheduleRow_Previews: PreviewProvider {
    static var previews: some View {
        VStack(alignment: .leading) {
            List {
                ScheduleRow(parameters: .constant(ScheduleParameters(
                    selectedFrequency: "Daily",
                    selectedDays: [],
                    selectedDate: Date(),
                    selectedTime: Date(),
                    isChecked: false
                )))
                ScheduleRow(parameters: .constant(ScheduleParameters(
                    selectedFrequency: "Weekly",
                    selectedDays: ["Mo", "Tu"],
                    selectedDate: Date(),
                    selectedTime: Date(),
                    isChecked: true
                )))
                ScheduleRow(parameters: .constant(ScheduleParameters(
                    selectedFrequency: "Once",
                    selectedDays: ["Mo", "Tu"],
                    selectedDate: Date(),
                    selectedTime: Date(),
                    isChecked: true
                )))
            }
        }
    }
}
