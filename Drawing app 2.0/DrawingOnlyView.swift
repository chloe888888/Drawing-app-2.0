//
//  DrawingOnlyView.swift
//  Drawing app 2.0
//
//  Created by Chloe Lin on 19/7/25.
//

import SwiftUI

struct DrawingOnlyView: View {
    var lines: [Line]
    var body: some View {
        ZStack {
            Color.white
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
        }
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
    }
}
