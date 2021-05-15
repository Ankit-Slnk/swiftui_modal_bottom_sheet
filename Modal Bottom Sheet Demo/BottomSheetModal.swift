//
//  BottomSheetModal.swift
//  AdFoodz
//
//  Created by WEBBRAINS on 08/05/21.
//

import SwiftUI

struct BottomSheetModal<Content: View>: View {
    
    private let backgroundOpacity = 0.65
    private let dragIndicatorVerticalPadding: CGFloat = 20
    @State private var offset = CGSize.zero
    @Binding var display: Bool
    
    var content: () -> Content
    
    var body: some View {
        ZStack(alignment: .bottom) {
            if display {
                background
                modal
            }
        }
        .animation(.spring())
        .transition(.move(edge: .bottom))
        .edgesIgnoringSafeArea(.all)
    }
    
    private var background: some View {
        Color.black
            .fillParent()
            .opacity(backgroundOpacity)
            .onTapGesture {
                display.toggle()
            }
    }
    
    private var modal: some View {
        VStack {
            //            indicator
            self.content()
        }
        .frame(width: UIScreen.screenWidth, height: CGFloat((UIScreen.screenHeight / 2)), alignment: .top)
        .background(Color.white)
        .cornerRadius(0)
        .offset(y: offset.height)
        .gesture(
            DragGesture()
                .onChanged { value in self.onChangedDragValueGesture(value) }
                .onEnded { value in self.onEndedDragValueGesture(value) }
        )
        .transition(.move(edge: .bottom))
    }
    
    //    private var indicator: some View {
    //        DragIndicator()
    //            .padding(.vertical, dragIndicatorVerticalPadding)
    //    }
    
    private func onChangedDragValueGesture(_ value: DragGesture.Value) {
        guard value.translation.height > 0 else { return }
        self.offset = value.translation
    }
    
    private func onEndedDragValueGesture(_ value: DragGesture.Value) {
        guard value.translation.height >= (CGFloat((UIScreen.screenHeight / 2)) / 2) else {
            self.offset = CGSize.zero
            return
        }
        
        withAnimation {
            self.display.toggle()
            self.offset = CGSize.zero
        }
    }
}

//struct DragIndicator: View {
//    private let width: CGFloat = 60
//    private let height: CGFloat = 6
//    private let cornerRadius: CGFloat = 4
//
//    var body: some View {
//        Rectangle()
//            .fill(Color.black)
//            .frame(width: width, height: height)
//            .cornerRadius(cornerRadius)
//    }
//}

struct BottomSheetModal_Previews: PreviewProvider {
    static var previews: some View {
        BottomSheetModal(display: .constant(true)) {
            Text("Bottom Sheet Modal")
                .font(Font.system(.headline))
                .foregroundColor(Color.white)
        }
    }
}
