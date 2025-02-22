import SwiftUI
import AVFoundation

struct ThreeThingsToHearView: View {
    @State private var backgroundColor: Color = .gray
    @State private var audioPlayer: AVAudioPlayer?
    @State private var glowingIndex: Int? = nil
    @State private var tappedCircles: Set<Int> = []
    
    let sounds = ["MorningChirp", "Wind", "Rain"]
    let colors: [Color] = [.green, .yellow, .mint]
    
    var body: some View {
        ZStack {
            backgroundColor
                .ignoresSafeArea()
            
            LinearGradient(gradient: Gradient(colors: [Color.black.opacity(1.1), Color.black.opacity(0.5), Color.black.opacity(1.1)]),
                           startPoint: .top,
                           endPoint: .bottom)
            .ignoresSafeArea()
            
            VStack(spacing: 50) {
                Text("The Power of 3 Sounds - Tap, Listen, Glow")
                    .font(.title2)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white)
                    .padding(.bottom, 10)
                
                ForEach(0..<3, id: \ .self) { index in
                    GlowingSoundButton(isGlowing: glowingIndex == index, color: colors[index]) {
                        handleTap(index: index)
                    }
                }
                
                Button(action: {
                }) {
                    Text("Continue")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: 220, height: 50)
                        .background(tappedCircles.count == 3 ? Color.blue : Color.gray)
                        .cornerRadius(12)
                        .shadow(radius: 5)
                }
                .disabled(tappedCircles.count < 3)
            }
        }
    }
    
    func handleTap(index: Int) {
        if glowingIndex == index {
            // If the same button is tapped again, stop the music and remove glow
            stopSound()
            glowingIndex = nil
            backgroundColor = .gray
        } else {
            // Play the new sound and update the UI
            playSound(named: sounds[index])
            backgroundColor = colors[index]
            glowingIndex = index
            tappedCircles.insert(index)
        }
    }
    
    func playSound(named sound: String) {
        if let url = Bundle.main.url(forResource: sound, withExtension: "mp3") {
            do {
                audioPlayer?.stop()
                audioPlayer = try AVAudioPlayer(contentsOf: url)
                audioPlayer?.play()
            } catch {
                print("Error loading sound")
            }
        } else {
            print("Could not find sound file: \(sound).mp3")
        }
    }
    
    func stopSound() {
        audioPlayer?.stop()
    }
}

struct GlowingSoundButton: View {
    var isGlowing: Bool
    var color: Color
    var action: () -> Void
    
    var body: some View {
        Circle()
            .fill(color)
            .frame(width: 100, height: 100)
            .overlay(
                Circle()
                    .stroke(color.opacity(isGlowing ? 0.8 : 0), lineWidth: 10)
                    .blur(radius: 8)
                    .animation(isGlowing ? Animation.easeInOut(duration: 1).repeatForever(autoreverses: true) : .default, value: isGlowing)
            )
        .frame(width: 250, height: 150)
            .onTapGesture {
                action()
            }
            .shadow(radius: 10)
    }
}
