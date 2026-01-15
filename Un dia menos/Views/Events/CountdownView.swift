import SwiftUI

enum CountdownUnit: CaseIterable {
    case seconds, minutes, hours, days, weeks, years

    var label: String {
        switch self {
        case .seconds: "Seg"
        case .minutes: "Min"
        case .hours: "Horas"
        case .days: "Días"
        case .weeks: "Sem"
        case .years: "Años"
        }
    }
}

struct CountdownView: View {
    let target: Date
    let unit: CountdownUnit
    let tint: Color

    @State private var now = Date()
    private let timer = Timer.publish(every: 0.25, on: .main, in: .common).autoconnect()

    var body: some View {
        let delta = max(0, target.timeIntervalSince(now))
        let value = convert(delta: delta, unit: unit)

        VStack(alignment: .leading, spacing: 8) {
            Text(target < now ? "Finalizado" : "Queda")
                .font(.caption)
                .foregroundStyle(.secondary)

            HStack(alignment: .firstTextBaseline, spacing: 10) {
                Text(format(value))
                    .font(.system(size: 44, weight: .semibold, design: .rounded))
                    .foregroundStyle(.primary)

                Text(unitFull(unit))
                    .font(.headline)
                    .foregroundStyle(tint)
            }

            ProgressView(value: progress(now: now, target: target))
                .tint(tint)
        }
        .onReceive(timer) { now = $0 }
        .animation(.spring(response: 0.35, dampingFraction: 0.9), value: unit)
    }

    private func convert(delta: TimeInterval, unit: CountdownUnit) -> Double {
        switch unit {
        case .seconds: return delta
        case .minutes: return delta / 60
        case .hours: return delta / 3600
        case .days: return delta / 86400
        case .weeks: return delta / (86400 * 7)
        case .years: return delta / (86400 * 365.25)
        }
    }

    private func unitFull(_ u: CountdownUnit) -> String {
        switch u {
        case .seconds: "segundos"
        case .minutes: "minutos"
        case .hours: "horas"
        case .days: "días"
        case .weeks: "semanas"
        case .years: "años"
        }
    }

    private func format(_ v: Double) -> String {
        if unit == .seconds { return String(Int(v.rounded(.down))) }
        if unit == .minutes || unit == .hours { return String(format: "%.1f", v) }
        return String(format: "%.2f", v)
    }

    // Progreso visual (simple): desde “ahora” hasta el target, asumiendo ventana 30 días por estética
    private func progress(now: Date, target: Date) -> Double {
        let window: TimeInterval = 86400 * 30
        let remaining = max(0, target.timeIntervalSince(now))
        let p = 1.0 - min(1.0, remaining / window)
        return max(0, min(1, p))
    }
}
