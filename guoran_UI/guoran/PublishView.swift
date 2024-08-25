//
//  PublishView.swift
//  guoran
//
//  Created by Bowen on 4/21/24.
//

import SwiftUI

struct PublishView: View {
//    @EnvironmentObject var navigationController: NavigationController
//    @Environment(\.presentationMode) var presentationMode
    var body: some View {
//        HStack{Text("发布成功!")
//                Image(systemName: "hand.thumbsup.fill")}
        Text("发布成功!").onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//                    presentationMode.wrappedValue.dismiss()
                    NavigationLink("前往子视图", destination: ContentView().navigationBarBackButtonHidden(true)
                        .navigationBarHidden(true)
                      )
                    
                }
            }
        //        Button("返回到根视图") {
        //                        navigationController.shouldPopToRoot = true
        //                    }
             
//        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//                ContentView()
//                                                }
    }
}

#Preview {
    PublishView()
}



