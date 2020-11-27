//
//  ContentView.swift
//  AutoScrollView
//
//  Created by Kenan Begić on 27/11/2020.
//

import SwiftUI

class ObservableText: ObservableObject {
    @Published var messageText: String = "Type message here..."
}

struct ChatView: View {
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    @GestureState private var dragOffset = CGSize.zero
    @State private var observableText = ObservableText()
    @State private var scrollTarget: Int?
    @State var height: CGFloat = 0
    @State var keyboardHeight: CGFloat = 0
    @ObservedObject var messagesStore = MessagesStore()
    var id: Int = 1
    
    //MARK: Image picker config
    init(messagesStore: MessagesStore) {
        self.messagesStore = messagesStore
        UINavigationBar.appearance().barTintColor = UIColor(named: "colorPrimary")
        UINavigationBar.appearance().backgroundColor = UIColor(named: "colorPrimary")
        UITableView.appearance().backgroundColor = UIColor(named: "backgroundColorList")
        UITextView.appearance().backgroundColor = .clear
        UIScrollView.appearance().bounces = true
    }
    
    //MARK: custom scrollview
    var scrollView : some View {
        ScrollView(.vertical) {
            ScrollViewReader { scrollView in
                ForEach(self.messagesStore.messages) { msg in
                    VStack {
                            OutgoingPlainMessageView() {
                                Text(msg.message)
                                    .padding(.all, 20)
                                    .foregroundColor(Color.textColorPrimary)
                                    .background(Color.colorPrimary)
                            }.listRowBackground(Color.backgroundColorList)
                        Spacer()
                    }
                    .id(msg.id)
                    .padding(.leading, 10).padding(.trailing, 10)
                }
                .onChange(of: scrollTarget) { target in
                    withAnimation {
                        scrollView.scrollTo(target, anchor: .bottom)
                    }
                }
                .onChange(of: keyboardHeight){ target in
                    if(nil != scrollTarget){
                        withAnimation {
                            scrollView.scrollTo(scrollTarget, anchor: .bottom)
                        }
                    }
                }
                .onReceive(self.messagesStore.$messages) { messages in
                    scrollView.scrollTo(messages.last!.id, anchor: .bottom)
                    self.scrollTarget = messages.last!.id
                }
            }
        }
    }
    
    //MARK: View body
    var body: some View {
        ZStack {
            Color.backgroundColorList.edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
            VStack {
                if (self.messagesStore.messages.first != nil) {
                    scrollView.onTapGesture(perform: {
                        UIApplication.shared.windows.first?.rootViewController?.view.endEditing(true)
                    })
                }
                Divider()
                HStack(spacing: 10) {
                    ResizableTF(observableText: self.observableText, height: self.$height)
                        .frame(height: self.height < 120 ? self.height : 120)
                        .padding(.horizontal)
                        .background(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 0.5).background(Color.backgroundColorList))
                    Button(action: {
                        appendChatMessage()
                    }) {
                        Image("ic_send").resizable().frame(width: 40, height: 40, alignment: .center)
                    }
                }
                .padding(.leading, 10).padding(.trailing, 10)
                //.padding(.bottom, 50)
                .padding(.bottom, 20)
            }
            //.padding(.bottom, self.keyboardHeight)
            .onAppear(){
                NotificationCenter.default.addObserver(forName: UIResponder.keyboardDidShowNotification, object: nil, queue: .main) { (data) in
                    let height = data.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
                    self.keyboardHeight = height.cgRectValue.height
                }
                NotificationCenter.default.addObserver(forName: UIResponder.keyboardDidHideNotification, object: nil, queue: .main){ (_) in
                    self.keyboardHeight = 0
                }
            }
            .background(Color.backgroundColorList)
            .foregroundColor(Color.textColorSecondary)
            .navigationViewStyle(StackNavigationViewStyle())
            .gesture(DragGesture().updating($dragOffset, body: { (value, state, transaction) in
                if(value.startLocation.x < 20 && value.translation.width > 100) {
                    self.mode.wrappedValue.dismiss()
                }
            }))
        }
    }
    
    //MARK: Create new message
    func appendChatMessage(){
        let newId = messagesStore.messages.last!.id + 1
        let message = Message(id: newId, message: observableText.messageText, message_timestamp: Int(Date().timeIntervalSince1970))
        self.messagesStore.messages.append(message)
        observableText.messageText = ""
    }
}
