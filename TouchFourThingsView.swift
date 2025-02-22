import SwiftUI
import CoreHaptics
import AVFoundation

struct TouchFourThingsView: View {
    @State private var tappedCards: Set<String> = []
    @State private var navigateNext = false
    @State private var hapticEngine: CHHapticEngine?

    let items = [
        ("cotton_image", "soft_buzz"),
        ("sandpaper_image", "rough_pulses"),
        ("glass_image", "sharp_taps"),
        ("wood_image", "random_pulses")
    ]

    var body: some View {
        NavigationStack {
            ZStack {
                Color.mint.edgesIgnoringSafeArea(.all)
                LinearGradient(gradient: Gradient(colors: [Color.black.opacity(1.1), Color.black.opacity(0.5), Color.black.opacity(1.1)]),
                               startPoint: .top,
                               endPoint: .bottom)
                    .ignoresSafeArea()

                VStack {
                    Text("Touch and Feel the 4 Vibrations")
                        .font(.title)
                        .multilineTextAlignment(.center)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.bottom, 10)

                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
                        ForEach(items, id: \.0) { item in
                            TouchCard(imageName: item.0, hapticType: item.1) {
                                tappedCards.insert(item.0)
                                playHapticFeedback(for: item.1)
                            }
                        }
                    }
                    .padding()

                    NavigationLink(destination: ThreeThingsToHearView(), isActive: $navigateNext) {
                        Text("Continue")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .padding()
                            .frame(width: 250, height: 55)
                            .background(tappedCards.count == 4 ? Color.white : Color.gray)
                            .foregroundColor(.mint)
                            .cornerRadius(12)
                            .shadow(radius: 5)
                    }
                    .disabled(tappedCards.count < 4)
                    .padding(.top, 30)
                }
            }
            .onAppear {
                prepareHaptics()
            }
        }
    }

    func prepareHaptics() {
        do {
            hapticEngine = try CHHapticEngine()
            try hapticEngine?.start()
        } catch {
            print("Haptic Engine Error: \(error.localizedDescription)")
        }
    }

    func playHapticFeedback(for type: String) {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }

        var events = [CHHapticEvent]()

        switch type {
        case "soft_buzz":
            let softBuzz = CHHapticEvent(eventType: .hapticContinuous, parameters: [
                CHHapticEventParameter(parameterID: .hapticIntensity, value: 0.3),
                CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.2)
            ], relativeTime: 0, duration: 0.3)
            events.append(softBuzz)

        case "rough_pulses":
            for i in stride(from: 0, to: 0.5, by: 0.1) {
                let pulse = CHHapticEvent(eventType: .hapticTransient, parameters: [
                    CHHapticEventParameter(parameterID: .hapticIntensity, value: 0.8),
                    CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.9)
                ], relativeTime: i)
                events.append(pulse)
            }

        case "sharp_taps":
            for i in stride(from: 0, to: 0.4, by: 0.1) {
                let tap = CHHapticEvent(eventType: .hapticTransient, parameters: [
                    CHHapticEventParameter(parameterID: .hapticIntensity, value: 0.5),
                    CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.7)
                ], relativeTime: i)
                events.append(tap)
            }

        case "random_pulses":
            for i in stride(from: 0, to: 0.6, by: 0.15) {
                let intensity = Float.random(in: 0.5...1.0)
                let sharpness = Float.random(in: 0.4...1.0)
                let pulse = CHHapticEvent(eventType: .hapticTransient, parameters: [
                    CHHapticEventParameter(parameterID: .hapticIntensity, value: intensity),
                    CHHapticEventParameter(parameterID: .hapticSharpness, value: sharpness)
                ], relativeTime: i)
                events.append(pulse)
            }

        default:
            break
        }

        do {
            let pattern = try CHHapticPattern(events: events, parameters: [])
            let player = try hapticEngine?.makePlayer(with: pattern)
            try player?.start(atTime: CHHapticTimeImmediate)
        } catch {
            print("Haptic Feedback Error: \(error.localizedDescription)")
        }
    }
}

struct TouchCard: View {
    let imageName: String
    let hapticType: String
    var onTap: () -> Void

    var body: some View {
        Button(action: {
            onTap()
        }) {
            Image(imageName)
                .resizable()
                .scaledToFill()
                .frame(width: 200, height: 200) // Match card size
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.white.opacity(0.8), lineWidth: 2)
                )
        }
        .frame(width: 250, height: 250)
    }
}
