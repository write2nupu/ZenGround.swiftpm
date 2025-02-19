import SwiftUI
import CoreHaptics

struct TouchFourThingsView: View {
    @State private var tappedCards: Set<String> = []
    @State private var navigateNext = false
    @State private var hapticEngine: CHHapticEngine?

    let items = [
        ("Cotton", "cotton_image", "soft_buzz"),
        ("Sandpaper", "sandpaper_image", "rough_pulses"),
        ("Glass", "glass_image", "sharp_taps"),
        ("Wood", "wood_image", "random_pulses")
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
                    Text("Touch 4 Things")
                        .font(.title)
                        .multilineTextAlignment(.center)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.bottom, 10)

                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
                        ForEach(items, id: \.0) { item in
                            TouchCard(name: item.0, imageName: item.1, hapticType: item.2) {
                                tappedCards.insert(item.0)
                                playHapticFeedback(for: item.2)
                            }
                        }
                    }
                    .padding()

                    // Continue Button (Disabled Until All 4 Cards Tapped)
                    NavigationLink(destination: NextView(), isActive: $navigateNext) {
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
            // Gentle, continuous buzz for 0.3 sec
            let softBuzz = CHHapticEvent(eventType: .hapticContinuous, parameters: [
                CHHapticEventParameter(parameterID: .hapticIntensity, value: 0.3),
                CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.2)
            ], relativeTime: 0, duration: 0.3)
            events.append(softBuzz)

        case "rough_pulses":
            // Strong, rough pulses for 0.5 sec
            for i in stride(from: 0, to: 0.5, by: 0.1) {
                let pulse = CHHapticEvent(eventType: .hapticTransient, parameters: [
                    CHHapticEventParameter(parameterID: .hapticIntensity, value: 0.8),
                    CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.9)
                ], relativeTime: i)
                events.append(pulse)
            }

        case "sharp_taps":
            // Light, sharp taps for 0.4 sec
            for i in stride(from: 0, to: 0.4, by: 0.1) {
                let tap = CHHapticEvent(eventType: .hapticTransient, parameters: [
                    CHHapticEventParameter(parameterID: .hapticIntensity, value: 0.5),
                    CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.7)
                ], relativeTime: i)
                events.append(tap)
            }

        case "random_pulses":
            // Randomized pulses for 0.6 sec
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

// Touch Card with Core Haptics
struct TouchCard: View {
    let name: String
    let imageName: String
    let hapticType: String
    var onTap: () -> Void

    var body: some View {
        Button(action: {
            onTap()
        }) {
            VStack {
                Image(imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .cornerRadius(12)

                Text(name)
                    .foregroundColor(.white)
                    .font(.headline)
            }
            .padding()
            .background(Color.white.opacity(0.2))
            .cornerRadius(12)
            .shadow(radius: 5)
        }
    }
}

// Placeholder for Next Page
struct NextView: View {
    var body: some View {
        Text("Next Activity")
            .font(.largeTitle)
            .foregroundColor(.white)
            .background(Color.black.ignoresSafeArea())
    }
}
