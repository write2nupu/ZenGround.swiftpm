import SwiftUI

struct GlowBackgroundView: View {
    @State private var showCameraView = false
    @State private var glowRadius: CGFloat = 10
    
    var body: some View {
        ZStack {
            Color.purple.edgesIgnoringSafeArea(.all)
            LinearGradient(gradient: Gradient(colors: [Color.black.opacity(1.1), Color.black.opacity(0.5), Color.black.opacity(1.1)]),
                           startPoint: .top,
                           endPoint: .bottom)
                .ignoresSafeArea()
            
            VStack {
                Image("Image")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 300, height: 300)
                    .clipShape(Circle()) // Makes the image round
                    .shadow(color: .purple, radius: glowRadius, x: 0, y: 0) // Glow effect animation
                    .animation(Animation.easeIn(duration: 1))
                    .padding(.top,60)

                Text("ZenGround")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .shadow(color: .purple, radius: 10, x: 0, y: 0)
                
                Text("Calm Your Mind, Reset Your Thoughts")
                    .font(.headline)
                    .foregroundColor(.white.opacity(0.8))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                    .padding(.top,1)
                
                Spacer()
                
                Button(action: {
                    showCameraView = true
                }) {
                    Text("Get Started")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .padding()
                        .frame(width:300, height:55)
                        .background(Color.white)
                        .foregroundColor(.purple)
                        .cornerRadius(12)
                        .shadow(radius: 5)
                }
                .padding(.horizontal, 40)
                .padding(.bottom, 70)
                .fullScreenCover(isPresented: $showCameraView) {
                    CaptureFiveObjectsView()
                }
            }
            .padding()
        }
    }
}
