//
//  IncomingPlainMessageView.swift
//  FashionBot
//
//  Created by Kenan Begić on 22/09/2020.
//

import SwiftUI

struct IncomingPlainMessageView<Content>: View where Content: View {
    let content: () -> Content
    
    init(@ViewBuilder content: @escaping () -> Content) {
                self.content = content
    }
    
    var body: some View {
        HStack {
            VStack {
                Spacer()
                Image("ic_bot").resizable().frame(width: 60, height: 60, alignment: .center)
            }
            content().clipShape(MessageShape(direction: .left))
            Spacer()
        }
    }
}
struct IncomingPlainMessageView_Previews: PreviewProvider {
    static var previews: some View {
        IncomingPlainMessageView() {
            Text("Hello!")
                .padding(.all, 20)
                .foregroundColor(Color.textColorPrimary)
                .background(Color.colorPrimary)
        }.listRowBackground(Color.backgroundColorList)
        .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
    }
}
