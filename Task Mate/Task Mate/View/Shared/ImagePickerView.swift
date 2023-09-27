//
//  ImagePickerView.swift
//  Task Mate
//
//  Created by Pau Fernández Solà on 6/5/23.
//

import SwiftUI

/// The detailed view used to represent a ImagePicker view.
struct ImagePickerView: View {
    
    @Binding var selectedImage: String
    
    let images = ["list.bullet", "tray.fill", "flag.fill", "gift.fill", "figure.walk", "cart.fill", "leaf.fill", "book.fill", "doc.fill", "house.fill", "building.columns.fill", "shippingbox.fill", "pawprint.fill", "creditcard.fill", "pills.fill", "stethoscope", "gamecontroller.fill", "headphones",
        "phone.fill",
        "lightbulb.fill",
        "lock.fill",
        "mappin",
        "takeoutbag.and.cup.and.straw.fill",
        "chart.pie.fill",
        "sun.max.fill",
        "moon.fill",
        "car.fill",
        "airplane",
        "snowflake",
        "flame.fill",
        "heart.fill",
        "circle.fill",
        "triangle.fill",
        "diamond.fill",
        "square.fill",
        "star.fill"
        ]
    
    let columns: [GridItem] = Array(repeating: GridItem(.flexible()), count: 6)
    
    var body: some View {
        LazyVGrid(columns: columns, spacing: 10) {
            ForEach(images, id: \.self) { image in
                ZStack {
                    Circle()
                        .foregroundColor(Color(UIColor.systemGray6))
                        .overlay(
                            Circle()
                                .stroke(selectedImage == image ? Color.secondary : .clear, lineWidth: 3)
                                .padding(-4)
                        )
                    
                    Image(systemName: image)
                        .foregroundColor(Color.primary.opacity(0.8))
                        .fixedSize()
                        .onTapGesture {
                            selectedImage = image
                        }
                }
            }
        }
    }
}
struct ImagePickerView_Previews: PreviewProvider {
    static var previews: some View {
        ImagePickerView(selectedImage: .constant("list.bullet"))
    }
}
