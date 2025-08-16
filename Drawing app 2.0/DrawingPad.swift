//
//  DrawingPad.swift
//  Drawing app 2.0
//
//  Created by Chloe Lin on 19/7/25.
//

import SwiftUI

struct DrawingPad: View {
    @Binding var lines: [Line]
    @Binding var undoneLines: [Line]
    @Binding var selectedColor: Color
    @Binding var lineWidth: CGFloat
    @Binding var isEraserOn: Bool
    
    @State private var currentLine = Line(points: [], color: .black, lineWidth: 5)
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                ForEach(lines.indices, id: \.self) { i in
                    Path { path in
                        let line = lines[i]
                        if let first = line.points.first {
                            path.move(to: first)
                            for point in line.points.dropFirst() {
                                path.addLine(to: point)
                            }
                        }
                    }
                    .stroke(lines[i].color, style: StrokeStyle(lineWidth: lines[i].lineWidth, lineCap: .round, lineJoin: .round))
                }
                
                Path { path in
                    if let first = currentLine.points.first {
                        path.move(to: first)
                        for point in currentLine.points.dropFirst() {
                            path.addLine(to: point)
                        }
                    }
                }
                .stroke(currentLine.color, style: StrokeStyle(lineWidth: currentLine.lineWidth, lineCap: .round, lineJoin: .round))
            }
            .contentShape(Rectangle())
            .gesture(DragGesture(minimumDistance: 0)
                .onChanged { value in
                    currentLine.color = isEraserOn ? .white : selectedColor
                    currentLine.lineWidth = lineWidth
                    currentLine.points.append(value.location)
                }
                .onEnded { _ in
                    lines.append(currentLine)
                    currentLine = Line(points: [], color: isEraserOn ? .white : selectedColor, lineWidth: lineWidth)
                    undoneLines.removeAll()
                }
            )
        }
    }
}
