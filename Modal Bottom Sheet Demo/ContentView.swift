//
//  HomeTabView.swift
//  AdFoodz
//
//  Created by WEBBRAINS on 06/05/21.
//

import SwiftUI

class StaticSelection: ObservableObject{
    
    var staticList: [String] = [
        "Static 1",
        "Static 2",
        "Static 3",
        "Static 4",
        "Static 5",
    ]
    
    @Published var selectedstaticList: Int = 0 {
        willSet {
            print("selectedstaticList", selectedstaticList)
        }
    }
}

class DynamicSelection: ObservableObject{
    
    var dynamicList: [String] = []
    
    @Published var selectedDynamicList: Int = 0 {
        willSet {
            print("selectedDynamicList", selectedDynamicList)
        }
    }
}

struct ContentView: View {
    @State private var showBottomSheet = false
    @ObservedObject var staticSelectionModel = StaticSelection()
    @ObservedObject var dynamicSelectionModel = DynamicSelection()
    
    var body: some View {
        
        dynamicSelectionModel.dynamicList.append("Dynamic 1")
        dynamicSelectionModel.dynamicList.append("Dynamic 2")
        dynamicSelectionModel.dynamicList.append("Dynamic 3")
        dynamicSelectionModel.dynamicList.append("Dynamic 4")
        dynamicSelectionModel.dynamicList.append("Dynamic 5")
        
        return ZStack{
            VStack{
                Button(action: {
                    showBottomSheet.toggle()
                }){
                    Text("Show Modal Bottom Sheet")
                        .fillWidth()
                        .font(.title3)
                        .frame(height: 60, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                        .foregroundColor(Color.white)
                        .background(Color.black)
                        .padding()
                }
            }
            .background(Color.white.shadow(color: Color("GreyColor1"), radius: 2, x: 0, y: 5))
            
            BottomSheetModal(display: $showBottomSheet) {
                VStack{
                    Text("Modal Bottom Sheet")
                        .font(.title2)
                        .foregroundColor(Color.black)
                        .padding(.horizontal)
                        .padding(.top , 16)
                    
                    divider()
                    
                    GeometryReader { geometry in
                        HStack(spacing: 0) {
                            Spacer()
                            Picker("Date", selection: $dynamicSelectionModel.selectedDynamicList) {
                                ForEach(0..<dynamicSelectionModel.dynamicList.count) { index in
                                    Text(dynamicSelectionModel.dynamicList[index]).tag(index)
                                }
                            }
                            .frame(
                                minWidth: 0,
                                maxWidth: (UIScreen.screenWidth / 2) - 16,
                                alignment: .center
                            )
                            .clipped()
                            .id(dynamicSelectionModel.dynamicList)
                            
                            Picker("Time Slot", selection: $staticSelectionModel.selectedstaticList) {
                                ForEach(0..<staticSelectionModel.staticList.count) { index in
                                    Text(staticSelectionModel.staticList[index]).tag(index)
                                }
                            }
                            .frame(
                                minWidth: 0,
                                maxWidth: (UIScreen.screenWidth / 2) - 16,
                                alignment: .center
                            )
                            .clipped()
                            
                            Spacer()
                        }
                    }
                    .mask(Rectangle())
                    
                    Button(action: {
                        showBottomSheet.toggle()
                    }){
                        HStack{
                            Text("Close")
                                .fillWidth()
                                .font(.title3)
                                .frame(height: 60, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                                .foregroundColor(Color.white)
                        }
                        .background(Color.black)
                        .fillWidth()
                        .padding(.bottom)
                    }
                    .padding(.horizontal)
                    .padding(.top)
                    
                }
            }
            
        }
    }
    
    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            ContentView()
        }
    }
}


extension UIScreen{
    static let screenWidth = UIScreen.main.bounds.size.width
    static let screenHeight = UIScreen.main.bounds.size.height
    static let screenSize = UIScreen.main.bounds.size
}

public extension View {
    func fillParent(alignment: Alignment = .center) -> some View {
        self
            .frame(
                minWidth: 0,
                maxWidth: .infinity,
                minHeight: 0,
                maxHeight: .infinity,
                alignment: alignment
            )
    }
    func fillHalfParent(alignment: Alignment = .center) -> some View {
        self
            .frame(
                minWidth: 0,
                maxWidth: UIScreen.screenWidth / 2,
                minHeight: 0,
                maxHeight: UIScreen.screenHeight / 2,
                alignment: alignment
            )
    }
    func fillSquare(alignment: Alignment = .center) -> some View {
        self
            .frame(
                minWidth: 0,
                maxWidth: UIScreen.screenWidth / 2,
                minHeight: 0,
                maxHeight: UIScreen.screenWidth / 2,
                alignment: alignment
            )
    }
    func fillHeight(alignment: Alignment = .center) -> some View {
        self
            .frame(
                minHeight: 0,
                maxHeight: .infinity,
                alignment: alignment
            )
    }
    func fillHalfHeight(alignment: Alignment = .center) -> some View {
        self
            .frame(
                minHeight: 0,
                maxHeight: UIScreen.screenHeight / 2,
                alignment: alignment
            )
    }
    func fillWidth(alignment: Alignment = .center) -> some View {
        self
            .frame(
                minWidth: 0,
                maxWidth: .infinity,
                alignment: alignment
            )
    }
    func fillHalfWidth(alignment: Alignment = .center) -> some View {
        self
            .frame(
                minWidth: 0,
                maxWidth: UIScreen.screenWidth / 2,
                alignment: alignment
            )
    }
    func divider(height: CGFloat = CGFloat(2)) -> some View {
        Rectangle()
            .fill(Color("GreyColor1"))
            .frame(height: height, alignment: .center)
    }
    func getSafeAreaEdgeInsets() -> UIEdgeInsets{
        return UIApplication.shared.windows.first!.safeAreaInsets
    }
}

extension Binding {
    func onChange(_ handler: @escaping (Value) -> Void) -> Binding<Value> {
        return Binding(
            get: { self.wrappedValue },
            set: { selection in
                self.wrappedValue = selection
                handler(selection)
            })
    }
}
