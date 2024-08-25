//
//  DetailView.swift
//  nutsv0
//
//  Created by Bowen on 3/16/24.
//

import SwiftUI

struct DetailView: View {
    @State var inputText: String = ""
    @Binding var isPresenting: Bool
    @State private var showPopup = false
    @State var gpt_response: GptResponse?
    @State private var isBlurred = false
    @State private var showMessage = false
    @State private var navigateToSecondView = false
    //    @StateObject var navController = NavigationController()/
    
    
    var body: some View {
        ZStack {
            Color.gray.opacity(0.1).ignoresSafeArea()
            
            VStack{
                Text("生成预览")
                    .padding()
                    .font(.system(size: 15))
                    .foregroundColor(Color.black)
                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .onAppear {
                                        GptApi().postImageUrl (promptText: inputText, completion: { (response) in
                                                self.gpt_response = response
                                            })
                                    }
                AsyncImage(url: URL(string: gpt_response?.image_url ?? "Loading Image...")) { image in
                    image.resizable()
                } placeholder: {
                    Text("Loading Image...")
                    ProgressView()
                }
                .frame(width: 300, height: 300)
                .cornerRadius(10)
                
                //                List{PostView(photoName: "postImage1")}.frame(height: 400)               //                Image("postImage1")
                //                    .resizable()
                //                    .aspectRatio(contentMode: .fill)
                //                    .frame(width: 380, height: 380, alignment: .top)
                //                .navigationTitle("创意生成")}
                //            .padding()
                
                HStack {
                    Text("加个标题？").padding(10).frame(maxWidth: .infinity, alignment: .leading)
                    
                    Text("自动生成标题").frame(width: 120,  height: 10)
                        .padding()
                        .foregroundColor(Color.orange)
                    //                        .background(Color.orange)
                    //                        .cornerRadius(10)
                    
                }
                TextField("请输入标题", text: $inputText)
                    .frame(height: 20, alignment: .top)
                    .padding(10)
                    .background(Color.white)
                    .cornerRadius(20)
                
                //                NavigationLink(destination: PublishView(), label: "Shit"){}
//                NavigationLink(destination: PublishView()) {
//                    HStack{Text("发布")}
//                        .frame(width: 380,  height: 50)
//                        .foregroundColor(Color.white)
//                        .background(Color.orange)
//                        .cornerRadius(10)
//                }
                VStack{
                    NavigationLink(destination: ContentView().navigationBarBackButtonHidden(true)
                        .navigationBarHidden(true)
                       .onAppear {
                           hideTabBar()
                       }
                       .onDisappear {
                           showTabBar()
                       }
                      , isActive: $navigateToSecondView) {
                        EmptyView()
                    }
                    Button("点击发布") {
                        
                        showPopup = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                            showPopup = false
                            isPresenting = false
                        }
//                        isPresenting = false
//                        DispatchQueue.main.asyncAfter(deadline: .now() + 1)
//                        {
//                            self.navigateToSecondView = true
//                        }
                    }.overlay(
                        popupView
                            .frame(width: 200, height: 100)
                            .background(Color.blue)
                            .cornerRadius(10)
                            .opacity(showPopup ? 1 : 0)
                            .animation(.easeInOut, value: showPopup))
                }.navigationTitle("New Post")
                    .navigationBarItems(trailing: Button("Cancel") {
                        isPresenting = false
                    })
                
                
                //                Spacer()
                
                //                HStack{
                ////                    Text("去修改").frame(width: 150,  height: 20)
                ////                        .padding()
                ////                        .foregroundColor(Color.white)
                ////                        .background(Color.gray.opacity(0.7))
                ////                        .cornerRadius(10)
                ////                    Spacer()
                ////                    Text("去发布").frame(width: 150,  height: 20)
                ////                        .padding()
                ////                        .foregroundColor(Color.white)
                ////                        .background(Color.orange)
                ////                        .cornerRadius(10).onTapGesture {
                ////                            print("发布成功！")
                ////                        }}.padding()
                //                NavigationView {
                //                            ZStack {
                //                                Button("点击发布") {
                //                                    // 触发虚化效果和显示消息
                //                                    withAnimation {
                //                                        isBlurred = true
                //                                        showMessage = true
                //                                    }
                //                                    // 2秒后隐藏消息和虚化效果，然后跳转回主页
                //                                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                //                                        withAnimation {
                //                                            isBlurred = false
                //                                            showMessage = false
                //                                        }
                ////
                ////
                //                                        NavigationLink(destination: PublishView()){}
                ////                                        // 跳转到主页的逻辑
                ////                                        // 这里假设你已经在NavigationView内部
                ////                                        // 可以使用`popToRootViewController`方法或者其他方式
                //                                    }
                //
                //                                .frame(width: 200, height: 50)
                //                                .background(Color.blue)
                //                                .foregroundColor(.white)
                //                                .cornerRadius(10)
                //
                //                                if showMessage {
                //                                    Text("成功发布")
                //                                        .font(.largeTitle)
                //                                        .foregroundColor(.white)
                //                                        .padding()
                //                                        .background(Color.black.opacity(0.5))
                //                                        .cornerRadius(10)
                //                                        .zIndex(1)  // 确保文字在最上层
                //                                }
                //                            }
                //                            .blur(radius: isBlurred ? 20 : 0) // 应用虚化效果
            }
            
            
            
            
            
        }
        
    }
    var popupView: some View {
            Text("发布成功～")
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .padding()
        }
    // 方法来隐藏底部 Tab Bar
    private func hideTabBar() {
        UITabBar.appearance().isHidden = true
    }
    
    // 方法来显示底部 Tab Bar
    private func showTabBar() {
        UITabBar.appearance().isHidden = false
    }
}

//#Preview {
//    DetailView()
//}
