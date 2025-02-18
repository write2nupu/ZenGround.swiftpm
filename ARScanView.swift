import SwiftUI
import ARKit
import RealityKit

struct ARScanView: UIViewControllerRepresentable {
    
    func makeUIViewController(context: Context) -> ARViewController {
        return ARViewController()
    }
    
    func updateUIViewController(_ uiViewController: ARViewController, context: Context) {}
}

class ARViewController: UIViewController, ARSessionDelegate {
    var arView: ARView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        arView = ARView(frame: view.bounds)
        view.addSubview(arView)
        
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = [.horizontal, .vertical] // Detect flat surfaces
        
        arView.session.run(configuration)
    }
}
