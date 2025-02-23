import SwiftUI

struct OneThingToTasteView: View {
    @State private var attemptsLeft = 3
    @State private var userGuess = ""
    @State private var blurAmount: CGFloat = 10
    @State private var message: String = ""
    @State private var showFinishButton = false
    @State private var showCalmMessage = false
    
    @Environment(\.presentationMode) var presentationMode
    
    let tasteItem = (image: "chocolate", name: "Chocolate", description: "A sweet and creamy delight, loved by many.")
    
    var body: some View {
        ZStack {
            Color.brown.edgesIgnoringSafeArea(.all)
            LinearGradient(gradient: Gradient(colors: [Color.black.opacity(1.1), Color.black.opacity(0.5), Color.black.opacity(1.1)]),
                           startPoint: .top,
                           endPoint: .bottom)
            .ignoresSafeArea()
            
            VStack(spacing: 20) {
                if showCalmMessage {
                    VStack(spacing: 15) {
                        Text("You did great! 🎉")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        
                        Text("Take a deep breath. You are safe, you are strong, and you are in control!")
                            .multilineTextAlignment(.center)
                            .foregroundColor(.yellow)
                            .padding()
                        
                        Image(systemName: "heart.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80, height: 80)
                            .foregroundColor(.red)
                        
                        Text("Whenever you feel anxious, remember: Just like today, you can always find a way to ground yourself. 🌿")
                            .multilineTextAlignment(.center)
                            .foregroundColor(.white)
                            .padding()
                        .padding()
                        .background(Color.white)
                        .foregroundColor(.blue)
                        .cornerRadius(10)
                    }
                    .padding()
                } else {
                    Text("Guess the Taste!")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    Text(tasteItem.description)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.white)
                        .padding()
                    
                    Image(tasteItem.image)
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
                    .foregroundColor(.blue)
                    .cornerRadius(10)
                    .disabled(showFinishButton)
                    
                    if showFinishButton {
                        Button("Finish") {
                            withAnimation {
                                showCalmMessage = true
                            }
                        }
                        .padding()
                        .background(Color.white)
                        .foregroundColor(.blue)
                        .cornerRadius(10)
                    }
                }
            }
            .padding()
        }
    }
    
    func checkGuess() {
        if userGuess.lowercased() == tasteItem.name.lowercased() {
            message = "✅ You guessed correct!"
            showFinishButton = true
        } else {
            attemptsLeft -= 1
            message = attemptsLeft > 0 ? "❌ Try again!" : "❌ Out of attempts! The answer was \(tasteItem.name)."
            if attemptsLeft == 0 {
                showFinishButton = true
            }
        }
    }
}
