//
//  ColorPickerView.swift
//  Task Mate
//
//  Created by Pau Fernández Solà on 6/5/23.
//

import SwiftUI

/// The detailed view used to represent a ColorPicker view.
struct ColorPickerView: View {
    
    @Binding var selectedColor: Color
    let columns: [GridItem] = Array(repeating: GridItem(.flexible()), count: 6)
    let colors: [Color] = [.red, .orange, .yellow, .green, .cyan, .blue, .purple, .pink, .indigo, .brown, .gray, .mint]
    
    var body: some View {
        LazyVGrid(columns: columns, spacing: 10) {
            ForEach(colors, id: \.self) { color in
                Circle()
                    .foregroundColor(color)
                    .overlay(
                        Circle()
                            .stroke(selectedColor == color ? Color.secondary : .clear, lineWidth: 3)
                            .padding(-4)
                        
                    )
                    .onTapGesture {
                        selectedColor = color
                    }
            }
        }
    }
}

struct ColorPickerView_Previews: PreviewProvider {
    static var previews: some View {
        ColorPickerView(selectedColor: .constant(.yellow))
    }
}
