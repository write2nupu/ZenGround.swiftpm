import SwiftUI

struct TwoThingsToSmellView: View {
    @State private var currentScentIndex = 0
    @State private var attemptsLeft = 3
    @State private var userGuess = ""
    @State private var blurAmount: CGFloat = 10
    @State private var message: String = ""
    @State private var showNextButton = false
    @State private var showContinueButton = false
    
    let scents = [
        (image: "coffee", name: "Coffee", description: "A rich, roasted aroma that wakes you up."),
        (image: "Orange", name: "Orange", description: "A fresh and citrusy scent, often used as a colour.")
    ]
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.pink.edgesIgnoringSafeArea(.all)
                LinearGradient(gradient: Gradient(colors: [Color.black.opacity(1.1), Color.black.opacity(0.5), Color.black.opacity(1.1)]),
                               startPoint: .top,
                               endPoint: .bottom)
                .ignoresSafeArea()
                
                VStack(spacing: 20) {
                    Text("Guess the Scent!")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    Text(scents[currentScentIndex].description)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.white)
                        .padding()
                    
                    Image(scents[currentScentIndex].image)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 250, height: 250)
                        .cornerRadius(15)
                        .blur(radius: blurAmount)
                        .onTapGesture {
                            if blurAmount > 0 {
                                blurAmount -= 3
                            }
                        }
                    
                    TextField("Enter your guess", text: $userGuess)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                        .multilineTextAlignment(.center)
                    
                    Text("Attempts left: \(attemptsLeft)")
                        .foregroundColor(.white)
                    
                    Text(message)
                        .foregroundColor(.yellow)
                        .fontWeight(.bold)
                    
                    Button("Submit Guess") {
                        checkGuess()
                    }
                    .padding()
                    .background(Color.white)
                    .foregroundColor(.pink)
                    .cornerRadius(10)
                    .disabled(showNextButton || showContinueButton)
                    
                    if showNextButton {
                        Button("Next Scent") {
                            nextScent()
                        }
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    }
                    
                    if showContinueButton {
                        NavigationLink(destination: OneThingToTasteView()) {
                            Text("Continue")
                                .font(.headline)
                                .foregroundColor(.pink)
                                .padding()
                                .frame(width: 220, height: 50)
                                .background(.white)
                                .cornerRadius(12)
                                .shadow(radius: 5)
                        }
                    }
                }
                .padding()
            }
        }
        .navigationViewStyle(StackNavigationViewStyle()) // 👈 Ensures single-view navigation
    }
    
    func checkGuess() {
        if userGuess.lowercased() == scents[currentScentIndex].name.lowercased() {
            message = "✅ You guessed correct!"
            if currentScentIndex == scents.count - 1 {
                showContinueButton = true
            } else {
                showNextButton = true
            }
        } else {
            attemptsLeft -= 1
            message = attemptsLeft > 0 ? "❌ Try again!" : "❌ Out of attempts! The answer was \(scents[currentScentIndex].name)."
            if attemptsLeft == 0 {
                if currentScentIndex == scents.count - 1 {
                    showContinueButton = true
                } else {
                    showNextButton = true
                }
            }
        }
    }
    
    func nextScent() {
        if currentScentIndex < scents.count - 1 {
            currentScentIndex += 1
            attemptsLeft = 3
            blurAmount = 10
            userGuess = ""
            message = ""
            showNextButton = false
        }
    }
}
