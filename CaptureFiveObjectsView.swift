import SwiftUI

struct CaptureFiveObjectsView: View {
    @State private var capturedImages: [UIImage] = []
    @State private var showCamera = false
    @State private var navigateToTouchView = false

    let columns = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())] // 3 columns for top row

    var body: some View {
        NavigationStack {
            ZStack {
                Color.purple.edgesIgnoringSafeArea(.all)
                LinearGradient(gradient: Gradient(colors: [Color.black.opacity(1.1), Color.black.opacity(0.5), Color.black.opacity(1.1)]),
                               startPoint: .top,
                               endPoint: .bottom)
                    .ignoresSafeArea()

                VStack {
                    Spacer().frame(height: 50) // Push content down

                    Text("Capture 5 Objects You Can See")
                        .font(.title)
                        .multilineTextAlignment(.center)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.top, 20) // Extra padding below safe area

                    // Grid layout for first 3 images
                    LazyVGrid(columns: columns, spacing: 10) {
                        ForEach(capturedImages.prefix(3), id: \.self) { image in
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 100, height: 100)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                    }
                    .frame(height: 100)
                    .padding(.top, 20) // More gap after text

                    // Centered HStack for the bottom 2 images
                    HStack(spacing: 20) {
                        ForEach(capturedImages.dropFirst(3), id: \.self) { image in
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 100, height: 100)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .center) // Centered alignment
                    .padding(.top, 20) // Extra spacing

                    Spacer() // Pushes button to bottom

                    // Capture Button
                    Button(action: {
                        if capturedImages.count < 5 {
                            showCamera = true
                        }
                    }) {
                        Text(capturedImages.count < 5 ? "Capture Object" : "Done")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .padding()
                            .frame(width: 250, height: 50)
                            .background(Color.white)
                            .foregroundColor(.purple)
                            .cornerRadius(12)
                            .shadow(radius: 5)
                    }
                    .padding(.bottom, 20)
                    .disabled(capturedImages.count >= 5)

                    // Continue Button (only when all 5 images are captured)
                    NavigationLink(destination: TouchFourThingsView(), isActive: $navigateToTouchView) {
                        Text("Continue")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .padding()
                            .frame(width: 250, height: 50)
                            .background(capturedImages.count == 5 ? Color.white : Color.gray)
                            .foregroundColor(.purple)
                            .cornerRadius(12)
                            .shadow(radius: 5)
                    }
                    .disabled(capturedImages.count < 5)
                    .padding(.bottom, 50)
                }
            }
            .sheet(isPresented: $showCamera) {
                CameraView(imageCaptured: { image in
                    if capturedImages.count < 5 {
                        capturedImages.append(image)
                    }
                    if capturedImages.count == 5 {
                        navigateToTouchView = true
                    }
                })
            }
        }
    }
}
