import SwiftUI

struct GradientBackgroundView: View {
    var body: some View {
        LinearGradient(gradient: Gradient(colors: [Color.black.opacity(1.1), Color.purple.opacity(1), Color.black.opacity(1.1)]),
                       startPoint: .top,
                       endPoint: .bottom)
            .ignoresSafeArea()
    }
}

struct GradientBackgroundView_Previews: PreviewProvider {
    static var previews: some View {
        GradientBackgroundView()
    }
}


struct ContentView: View {
    var body: some View {
        GradientBackgroundView()
            .overlay(
                Text("Welcome to ZenGround")
                    .font(.largeTitle)
                    .foregroundColor(.white)
                    .bold()
            )
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
