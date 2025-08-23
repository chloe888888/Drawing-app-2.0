//
//  ContentView.swift
//  Drawing app 2.0
//
//  Created by Chloe Lin on 19/7/25.
//


import SwiftUI
import PhotosUI

struct ContentView: View {
    @State private var lines: [Line] = []
    @State private var undoneLines: [Line] = []
    @State private var selectedColor: Color = .black
    @State private var lineWidth: CGFloat = 5
    @State private var isEraserOn = false
    @State private var showingSaveAlert = false
    @State private var selectedImage: UIImage?
    @State private var imageOffset: CGSize = .zero
    @State private var showingImagePicker = false
    
    var body: some View {
        VStack {
            DrawingPad(lines: $lines, undoneLines: $undoneLines, selectedColor: $selectedColor, lineWidth: $lineWidth, isEraserOn: $isEraserOn)
                .background(Color.white)
                .cornerRadius(10)
                .padding()
            
            Toolbar(selectedColor: $selectedColor,
                    lineWidth: $lineWidth,
                    isEraserOn: $isEraserOn,
                    lines: $lines,
                    undoneLines: $undoneLines, showingImagePicker: $showingImagePicker,
                    onSave: save,
                    showingSaveAlert: $showingSaveAlert)
            .padding()
        }
        .alert("Saved to Photos!", isPresented: $showingSaveAlert) {
            Button("OK", role: .cancel) {}
        }
        VStack {
            if let image = selectedImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .offset(imageOffset)
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                imageOffset = value.translation
                            }
                            .onEnded { value in
                            }
                    )
            } else {
                Text("Tap to select an image")
            }
        }
        .sheet(isPresented: $showingImagePicker) {
            
            PhotoPicker(selectedImage: $selectedImage)
        }
    }
    struct PhotoPicker: UIViewControllerRepresentable {
        @Binding var selectedImage: UIImage?
        
        func makeUIViewController(context: Context) -> PHPickerViewController {
            var config = PHPickerConfiguration()
            config.filter = .images
            let picker = PHPickerViewController(configuration: config)
            picker.delegate = context.coordinator
            return picker
        }
        
        func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}
        
        func makeCoordinator() -> Coordinator {
            Coordinator(self)
        }
        
        class Coordinator: NSObject, PHPickerViewControllerDelegate {
            let parent: PhotoPicker
            
            init(_ parent: PhotoPicker) {
                self.parent = parent
            }
            
            func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
                picker.dismiss(animated: true)
                
                guard let itemProvider = results.first?.itemProvider,
                      itemProvider.canLoadObject(ofClass: UIImage.self) else { return }
                
                itemProvider.loadObject(ofClass: UIImage.self) { [weak self] image, error in
                    DispatchQueue.main.async {
                        self?.parent.selectedImage = image as? UIImage
                    }
                }
            }
        }
    }
    private func save() {
        let image = snapshot()
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        showingSaveAlert = true
    }
    
    private func snapshot() -> UIImage {
        let controller = UIHostingController(rootView: DrawingOnlyView(lines: lines))
        let view = controller.view!
        let targetSize = UIScreen.main.bounds.size
        
        view.bounds = CGRect(origin: .zero, size: targetSize)
        view.backgroundColor = .clear
        
        let renderer = UIGraphicsImageRenderer(size: targetSize)
        return renderer.image { _ in
            view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
