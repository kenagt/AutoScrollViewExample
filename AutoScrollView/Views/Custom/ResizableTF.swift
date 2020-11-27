//
//  ResizableTF.swift
//  FashionBot
//
//  Created by Kenan Begić on 01/10/2020.
//

import Foundation
import SwiftUI

struct ResizableTF: UIViewRepresentable {

    @ObservedObject var observableText: ObservableText
    @Binding var height: CGFloat
    
    func makeCoordinator() -> Coordinator {
        return ResizableTF.Coordinator(parent: self)
    }

    func makeUIView(context: Context) -> UITextView {
        let view = UITextView()
        view.isEditable = true
        view.isScrollEnabled = true
        view.text = "Type message here..."
        view.font = .systemFont(ofSize: 19)
        view.textColor = .gray
        view.delegate = context.coordinator
        view.backgroundColor = .clear
        return view
    }
    
    func updateUIView(_ uiView: UITextView, context: Context) {
        DispatchQueue.main.async {
            self.height = uiView.contentSize.height
            uiView.text = self.observableText.messageText
        }
    }
    
    class Coordinator : NSObject, UITextViewDelegate {
        var parent : ResizableTF
        
        init(parent: ResizableTF) {
            self.parent = parent
        }
        
        func textViewDidBeginEditing(_ textView: UITextView){
            if self.parent.observableText.messageText == "Type message here..." {
                textView.text = ""
                self.parent.observableText.messageText = ""
                textView.textColor = UIColor(named: "textColorSecondary")
            }
        }
        
        func textViewDidEndEditing(_ textView: UITextView){
            textView.text = "Type message here..."
            textView.textColor = .gray
            self.parent.observableText.messageText = "Type message here..."
        }
        
        func textViewDidChange(_ textView: UITextView){
            DispatchQueue.main.async {
                self.parent.height = textView.contentSize.height
                self.parent.observableText.messageText = textView.text
            }
        }
    }
}
