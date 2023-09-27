//
//  TitlePickerView.swift
//  Task Mate
//
//  Created by Pau Fernández Solà on 6/5/23.
//

import SwiftUI

/// The detailed view used to represent a TitlePicker view.
struct TitlePickerView: View {
    
    @Binding var title: String
    @Binding var color: Color
    @Binding var image: String

    var body: some View {
            VStack(spacing: 20) {
                ZStack {
                    Circle()
                        .foregroundColor(.clear)
                        .background(LinearGradient(colors: [color, color.opacity(0.5)], startPoint: .bottom, endPoint: .top))
                        .frame(width: 100, height: 100)
                        .clipShape(Capsule())
                        .shadow(color: color, radius: 3)
                    
                    Image(systemName: image)
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.white)
                        .frame(width: 50, height: 50)
                }
                
                TextField("List Name", text: $title)
                    .multilineTextAlignment(.center)
                    .foregroundColor(color)
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding()
                    .autocorrectionDisabled()
                    .background(Color(UIColor.systemGray6))
                    .cornerRadius(15)
                    .onAppear {
                        UITextField.appearance().clearButtonMode = .whileEditing
                    }
        }
    }
}

struct TitlePickerView_Previews: PreviewProvider {
    static var previews: some View {
        TitlePickerView(title: .constant("Christmas"), color: .constant(.pink), image: .constant("gift.fill"))
    }
}
