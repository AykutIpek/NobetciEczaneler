//
//  DropdownView.swift
//  NobetciEczaneler
//
//  Created by aykut ipek on 20.08.2024.
//

import SwiftUI

struct DropdownView: View {
    let title: String
    let prompt: String
    let options: [String]
    
    @State private var isExpended = false
    @Binding var selection: String?
    
    var body: some View {
        VStack(alignment: .leading) {
            header
            VStack {
                cellView
                if isExpended {
                    listItems
                }
            }
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .shadow(radius: 4)
            .frame(width: 300)
        }
    }
    
    private var header: some View {
        Text(title)
            .font(.footnote)
            .foregroundStyle(.gray)
            .opacity(0.8)
    }
    
    private var cellView: some View {
        HStack {
            Text(selection ?? prompt)
            Spacer()
            Image(systemName: SystemImages.chevronDown.rawValue)
                .font(.subheadline)
                .foregroundStyle(.gray)
                .rotationEffect(.degrees(isExpended ? 180 : .zero))
        }
        .frame(height: 40)
        .background(Color.white)
        .padding(.horizontal)
        .onTapGesture {
            withAnimation(.snappy) {
                isExpended.toggle()
            }
        }
    }
    
    private var listItems: some View {
        ScrollView {
            ForEach(options, id: \.self) { option in
                HStack {
                    Text(option)
                        .foregroundStyle(selection == option ? Color.black : Color.gray)
                    Spacer()
                    if selection == option {
                        Image(systemName: SystemImages.checkmark.rawValue)
                            .font(.subheadline)
                    }
                }
                .frame(height: 40)
                .background(Color.white)
                .padding(.horizontal)
                .onTapGesture {
                    withAnimation(.snappy) {
                        selection = option
                        isExpended.toggle()
                    }
                }
            }
            
        }
        .frame(idealHeight: 100, maxHeight: 250)
        .transition(.move(edge: .bottom))
    }
}


#Preview {
    DropdownView(
        title: "İl",
        prompt: "İl Seçin",
        options: ["İzmir", "Ankara", "İstanbul"],
        selection: .constant("Ankara")
    )
}
