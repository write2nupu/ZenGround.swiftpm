import SwiftUI
import AVFoundation


struct ThreeThingsToHearView: View {
    @State private var backgroundColor: Color = .gray
    @State private var audioPlayer: AVAudioPlayer?
    @State private var glowingIndex: Int? = nil
    @State private var tappedCircles: Set<Int> = []
    @State private var isNavigating = false
    
    let sounds = ["MorningChirp", "Wind", "Rain"]
    let colors: [Color] = [.green, .yellow, .mint]
    
    var body: some View {
        NavigationStack {
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
                    
                    ForEach(0..<3, id: \.self) { index in
                        GlowingSoundButton(isGlowing: glowingIndex == index, color: colors[index]) {
                            handleTap(index: index)
                        }
                    }
                    
                    Button(action: {
                        stopSound() 
                        isNavigating = true
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
                .padding()
            }
            .navigationDestination(isPresented: $isNavigating) {
                TwoThingsToSmellView()
            }
        }
    }
    
    func handleTap(index: Int) {
        if glowingIndex == index {
            stopSound()
            glowingIndex = nil
            backgroundColor = .gray
        } else {
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
        glowingIndex = nil
        backgroundColor = .gray
    }
}
