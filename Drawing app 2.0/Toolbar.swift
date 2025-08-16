//
//  Toolbar.swift
//  Drawing app 2.0
//
//  Created by Chloe Lin on 19/7/25.
//

import SwiftUI
import PhotosUI

struct Toolbar: View {
    @Binding var selectedColor: Color
    @Binding var lineWidth: CGFloat
    @Binding var isEraserOn: Bool
    
    @Binding var lines: [Line]
    @Binding var undoneLines: [Line]
    @Binding var showingImagePicker = false

    
    var onSave: () -> Void
    @Binding var showingSaveAlert: Bool
    
    var body: some View {
        VStack(spacing: 15) {
            HStack {
                Text("Color:")
                ColorPicker("", selection: $selectedColor)
                    .labelsHidden()
                    .disabled(isEraserOn)
            }
            
            HStack {
                Text("Thickness: \(Int(lineWidth))")
                Slider(value: $lineWidth, in: 1...100)
            }
            
            Toggle(isOn: $isEraserOn) {
                Text("Eraser")
                    .fontWeight(.bold)
                    .foregroundColor(isEraserOn ? .red : .primary)
            }
            .padding(.horizontal)
            
            HStack(spacing: 30) {
                Button(action: undo) {
                    Image(systemName: "arrow.uturn.backward")
                }
                .disabled(lines.isEmpty)
                
                Button(action: redo) {
                    Image(systemName: "arrow.uturn.forward")
                }
                .disabled(undoneLines.isEmpty)
                
                Button(action: clear) {
                    Image(systemName: "trash")
                }
                .disabled(lines.isEmpty)
                
                Button(action: {
                    onSave()
                }) {
                    Image(systemName: "square.and.arrow.down")
                }
                .disabled(lines.isEmpty)
            }
            .font(.title)
        }
        Button("Select Image") {
            showingImagePicker = true
            
        }


    }
    
    private func undo() {
        guard !lines.isEmpty else { return }
        undoneLines.append(lines.removeLast())
    }
    
    private func redo() {
        guard !undoneLines.isEmpty else { return }
        lines.append(undoneLines.removeLast())
    }
    
    private func clear() {
        lines.removeAll()
        undoneLines.removeAll()
    }
}
