//
//  ContentView.swift
//  drag-and-drop
//
//  Created by 関根健悟 on 2025/05/27.
//

import SwiftUI

struct ContentView: View {
  @State private var arrColors: [Color] = [
    .red, .green, .blue, .yellow, .orange, .purple, .pink, .gray, .black, .white,
  ]
  @State private var draggingColor: Color?
  var body: some View {
    NavigationStack {
      ScrollView(.vertical) {
        let columns = Array(repeating: GridItem(spacing: 10), count: 3)
        LazyVGrid(
          columns: columns, spacing: 10,
          content: {
            ForEach(arrColors, id: \.self) { color in
              GeometryReader {
                let size = $0.size

                RoundedRectangle(cornerRadius: 10)
                  .fill(color.gradient)
                  /// Drag
                  .draggable(color) {
                    /// custom preview View
                    RoundedRectangle(cornerRadius: 10)
                      .fill(color.gradient.opacity(0.8))
                      .frame(width: size.width, height: size.height)
                      .onAppear {
                        draggingColor = color
                      }
                  }
                  ///Drop
                  .dropDestination(for: Color.self) { item, location in

                    return false
                  } isTargeted: { status in
                    if let draggingColor, status, draggingColor != color {
                      ///Moving Color from source to destination
                      if let sourceIndex = arrColors.firstIndex(
                        of:
                          draggingColor),
                        let destinationIndex =
                          arrColors.firstIndex(of: color)
                      {
                        withAnimation(.bouncy) {
                          let sourceItem = arrColors.remove(at: sourceIndex)
                          arrColors.insert(
                            sourceItem,
                            at:
                              destinationIndex)
                        }
                      }
                    }
                  }
              }
              .frame(height: 100)
            }
          }
        )
        .padding(15)
      }
      .navigationTitle("Movable Grid")
    }
  }
}

#Preview {
  ContentView()
}
