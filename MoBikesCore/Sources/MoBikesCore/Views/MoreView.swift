//
//  SwiftUIView.swift
//  
//
//  Created by Andrew on 2021-03-06.
//

import SwiftUI

public final class MoreViewModel: ObservableObject {
    @Published public var accountNumber: String = "" {
        didSet {
            // save to UserDefaults
            print("account number is", accountNumber)
        }
    }

    init(/* UserDefaults client */) {
        // fetch account number from UserDefaults
    }
}

struct MoreView: View {
    @ObservedObject var viewModel: MoreViewModel

    struct IconText: View {
        let icon: String
        let text: String
        
        var body: some View {
        Image(systemName: icon)
            .padding(.trailing, 3)
        Text(text)
            .frame(maxWidth: .infinity, alignment: .topLeading)
        }
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 5) {
                NavigationLink(destination: NumPadView(value: $viewModel.accountNumber,
                                                       navTitle: "Account",
                                                       maxLength: 7)) {
                    if viewModel.accountNumber.isEmpty {
                        IconText(icon: "pencil", text: "Save your account number")
                    } else {
                        VStack(alignment: .leading, spacing: 5) {
                            Text("Account Number:")
                                .font(Font.system(.caption))
                            Text(viewModel.accountNumber)
                                .font(.title)
                        }
                        .frame(maxWidth: .infinity, alignment: .topLeading)
                    }
                }

                HStack {
                    Link(destination: Constants.mobiPhoneNumber, label: {
                        IconText(icon: "phone.fill", text: "Call Mobi")
                    })
                }
            }
        }
    }
    
    public init(viewModel: MoreViewModel = MoreViewModel()) {
        self.viewModel = viewModel
    }
}

struct MoreView_Previews: PreviewProvider {
        
    static var previews: some View {
        MoreView()
    }
}
