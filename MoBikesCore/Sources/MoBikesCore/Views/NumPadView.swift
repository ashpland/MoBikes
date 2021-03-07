//
//  SwiftUIView.swift
//  
//
//  Created by Andrew on 2021-03-06.
//

import SwiftUI

struct NumPadView: View {
    @Binding var value: String {
        didSet {
            if value.count > maxLength {
                value = oldValue
            }
        }
    }
    let navTitle: String
    let maxLength: Int
    
    private struct PadButton: ButtonStyle {
        
        func makeBody(configuration: Self.Configuration) -> some View {
                configuration.label
                    .padding(.horizontal)
                    .padding(.vertical, 1)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(
                        ZStack {
                            RoundedRectangle(cornerRadius: 10, style: .continuous)
                                .fill(Color.Mo.primary)
                        }
                )
                    .scaleEffect(configuration.isPressed ? 0.95: 1)
                    .foregroundColor(.primary)
            }
    }
    
    private func numButton(_ num: Int) -> some View {
        let str = String(num)
        return Button(str) { value.append(str) }
                    .buttonStyle(PadButton())
    }
    
    private var delButton: some View {
        Button(action: { value = String(value.dropLast()) }, label: {
            Image(systemName: "delete.left")
        })
        .buttonStyle(PadButton())
        .padding(.trailing, 10)
    }
    
    private var clearButton: some View {
        Button(action: { value = "" }, label: {
            Image(systemName: "xmark.circle")
        })
        .buttonStyle(PadButton())
        .padding(.leading, 10)
    }
    
    private var ValuePreview: some View {
        HStack { Text(value); Text(" ") }
            .font(.title2)
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            ValuePreview
            HStack { numButton(1); numButton(2); numButton(3) }
            HStack { numButton(4); numButton(5); numButton(6) }
            HStack { numButton(7); numButton(8); numButton(9) }
            HStack { clearButton;  numButton(0); delButton }
        }
        .navigationTitle(navTitle)
        .padding(.bottom, 5)
        .ignoresSafeArea(edges: .bottom)

    }
    
    struct Previewer: View {
        @State var accountNumber: String = "9605459"

        var body: some View {
            NumPadView(value: $accountNumber,
                       navTitle: "Account",
                       maxLength: 7)
        }
    }
}

struct NumPadView_Previews: PreviewProvider {
    
    
    static var previews: some View {
        NumPadView.Previewer()
        
    }
}
