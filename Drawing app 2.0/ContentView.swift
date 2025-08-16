//
//  ContentView.swift
//  Drawing app 2.0
//
//  Created by Chloe Lin on 19/7/25.
//


import SwiftUI

struct ContentView: View {
    @State private var lines: [Line] = []
    @State private var undoneLines: [Line] = []
    @State private var selectedColor: Color = .black
    @State private var lineWidth: CGFloat = 5
    @State private var isEraserOn = false
    @State private var showingSaveAlert = false
    
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
                    undoneLines: $undoneLines,
                    onSave: save,
                    showingSaveAlert: $showingSaveAlert)
            .padding()
        }
        .alert("Saved to Photos!", isPresented: $showingSaveAlert) {
            Button("OK", role: .cancel) {}
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
