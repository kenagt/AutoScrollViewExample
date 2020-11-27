//
//  OutgoingPlainMessageView.swift
//  FashionBot
//
//  Created by Kenan Begić on 22/09/2020.
//

import SwiftUI

struct OutgoingPlainMessageView<Content>: View where Content: View {
    let content: () -> Content
    
    init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }
    
    var body: some View {
        HStack {
            Spacer()
            content().clipShape(MessageShape(direction: .right))
        }
    }
}

struct OutgoingPlainMessageView_Previews: PreviewProvider {
    static var previews: some View {
        OutgoingPlainMessageView() {
            Image("dummyImage")
                .resizable()
                .frame(width: UIScreen.main.bounds.width - 150, height: 200)
                .aspectRatio(contentMode: .fill)
                .background(Color.blue)
        }
        .listRowBackground(Color.blue)
    }
}
