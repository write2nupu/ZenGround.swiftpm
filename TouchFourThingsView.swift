import SwiftUI

struct TouchFourThingsView: View {
    @State private var tappedCards: Set<String> = []
    @State private var navigateNext = false
    
    let items = [
        ("Cotton", "cotton_image", UIImpactFeedbackGenerator.FeedbackStyle.light), // Gentle, short
        ("Sandpaper", "sandpaper_image", UIImpactFeedbackGenerator.FeedbackStyle.heavy), // Strong, sharp
        ("Glass", "glass_image", UIImpactFeedbackGenerator.FeedbackStyle.medium), // Light, long
        ("Wood", "wood_image", UIImpactFeedbackGenerator.FeedbackStyle.rigid) // Random strong
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
                        .font(.largeTitle)
                        .foregroundColor(.white)
                        .padding(.bottom, 10)

                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
                        ForEach(items, id: \.0) { item in
                            TouchCard(name: item.0, imageName: item.1, feedbackStyle: item.2) {
                                tappedCards.insert(item.0)
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
                            .foregroundColor(.purple)
                            .cornerRadius(12)
                            .shadow(radius: 5)
                    }
                    .disabled(tappedCards.count < 4)
                    .padding(.top, 30)
                }
            }
        }
    }
}

// Touch Card with Haptic Feedback
struct TouchCard: View {
    let name: String
    let imageName: String
    let feedbackStyle: UIImpactFeedbackGenerator.FeedbackStyle
    var onTap: () -> Void

    var body: some View {
        Button(action: {
            let generator = UIImpactFeedbackGenerator(style: feedbackStyle)
            generator.impactOccurred()
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
