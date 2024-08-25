//
//  ContentView.swift
//  nutsv0
//
//  Created by Bowen on 3/7/24.
//

//import SwiftUI
//
//struct ContentView: View {
//    var body: some View {
//        VStack {
//            Image(systemName: "globe")
//                .imageScale(.large)
//                .foregroundStyle(.tint)
//            Text("Hello, world!")
//        }
//        .padding()
//    }
//}
//
//#Preview {
//    ContentView()
//}

import SwiftUI

struct ContentView: View {
    @State private var isPresentingNewPost = false
    @State private var inputText: String = ""
    @State private var characterLimit = 100
//    @EnvironmentObject var navigationController: NavigationController
    
    var body: some View {
//        NavigationView{
//            List {
//                ForEach(0..<10) { index in
//                    PostView(photoName: "postImage\(index)")
//                }
//            }.tabItem {
//                Image(systemName: "house.fill")
//                Text("主页")
//        }
        TabView {
            NavigationView {
                List {
                    ForEach(0..<10) { index in
                        PostView(photoName: "postImage\(index)")
                    }
                }
                //                        .navigationBarTitle(Text("坚果"), displayMode: .inline)
            }
            .tabItem {
                Image(systemName: "house.fill")
                Text("主页")
            }
            
            
            // 生成界面
            NavigationView{
                ZStack {
                    Color.gray.opacity(0.1)
                    
                    VStack {
                        //背景照片
                        Image("backphoto") // 替换为您的图片资源名
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width:400, height: 100, alignment: .top)
                            .clipped()
                        
                        ZStack {
                            //                            Color.white.frame(height: 200)
                            VStack {
                                VStack{TextField("今天有什么灵感？", text: $inputText)
                                        .padding(10)
                                        .frame(height: 100, alignment: .top)
                                    .background(Color.white)}
                                //                                    Spacer()
                                
                                //                                    Divider()
                                HStack {
                                    Text("常用提示:")
                                        .padding(10)
                                        .font(.system(size: 15))
                                    Text("写实")
                                        .padding(5)
                                        .font(.system(size: 15))
                                        .frame(height:20)
                                        .background(Color.white)
                                        .cornerRadius(5)
                                        .shadow(radius: 5)
                                    Text("光影")
                                        .padding(5)
                                        .font(.system(size: 15))
                                        .frame(height:20)
                                        .background(Color.white)
                                        .cornerRadius(5)
                                        .shadow(radius: 5)
                                    Text("2001太空漫游")
                                        .padding(5)
                                        .font(.system(size: 15))
                                        .frame(height:20)
                                        .background(Color.white)
                                        .cornerRadius(5)
                                        .shadow(radius: 5)
                                    Spacer()
                                    Text("\(characterLimit - inputText.count)/100")
                                        .foregroundColor(.gray)
                                        .padding(5)
                                        .font(.system(size: 10))
                                }
                                Button("生成") {
                                    isPresentingNewPost = true
                                }.sheet(isPresented: $isPresentingNewPost) {
                                    DetailView(inputText: inputText, isPresenting: $isPresentingNewPost)
                                }
                                
                                
                                
                            }.frame(height: 200).background(.white).cornerRadius(20)
                            
                            
                                .tabItem {
                                    Label("发布", systemImage: "square.and.pencil")
                                }
                            //                            .sheet(isPresented: $isPresentingNewPost) {
                            //                                DetailView(inputText: inputText, isPresenting: $isPresentingNewPost)
                            //                            }
                            
                            //                            NavigationLink(destination: DetailView(inputText: inputText)) {
                            //                                HStack{Image(systemName: "lightbulb.max")
                            //                                    Text("生成")}
                            //                                .frame(width: 380,  height: 50)
                            //                                .foregroundColor(Color.white)
                            //                                .background(Color.orange)
                            //                                .cornerRadius(10)
                        }
                        
                        
                        
                        //                            Button(action: {
                        //                                        // Your action goes here
                        //                                        viewGptResult()
                        //                                    }) {
                        //                                        Text("Click me!")
                        //                                    }
                        //                        .navigationBarTitle("Home", displayMode: .inline)
                        //                    Button("🌰生成") {
                        //                        // 处理发送动作
                        //                    }
                        //                    .frame(width: 380,  height: 50)
                        //                    .foregroundColor(Color.white)
                        //                    .background(Color.orange)
                        //                    .cornerRadius(10)
                        //                    .padding()
                        //                Spacer()
                        //文字
                        HStack{
                            Text("看看别人的灵感")
                                .padding()
                                .font(.subheadline)
                                .foregroundColor(Color.gray)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        
                        // 定义网格布局
                        var gridLayout: [GridItem] {
                            // 设置spacing参数来定义行之间的最小间距
                            return Array(repeating: GridItem(.flexible(), spacing: -30), count: 2)
                        }
                        // 图片网格
                        ScrollView(.horizontal) {
                            LazyHGrid(rows: gridLayout, alignment: .top, spacing: 10) {
                                ForEach(1..<15) { photo in
                                    Image("image\(String(photo))") // 替换为您的图片资源名
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 110, height:110)
                                        .cornerRadius(10)
                                }
                            }
                        }.frame(height:280)
                        
                    }
                }}
            .tabItem {
                Image(systemName: "plus.square")
                Text("创作")
            }
            //.background(Color.gray.opacity(0.1))
            
            // 根据需要为周围环境添加空间
            //                            .shadow(radius: 1)
            //                            .border(Color.gray, width: 0)
            
            // 字符计数和按钮
            //                        HStack {
            //                            Text("剩余字符：\(characterLimit - inputText.count)")
            //                            Spacer()
            //                            Button("取消") {
            //                                // 处理取消动作
            //                            }
            //                            .foregroundColor(Color.blue)
            //                            Button("清空") {
            //                                inputText = ""
            //                            }
            //                            .foregroundColor(Color.red)
            //                            Button("生成") {
            //                                // 处理发送动作
            //                            }
            //                            .frame(width:200, height: 50)
            //                            .foregroundColor(Color.white)
            //                            .background(Color.orange)
            //                            .cornerRadius(10)
            //                            .padding()
            //                        }
            //                        .padding(.horizontal)
            //                    }
            
            //                    .background(Color.gray.opacity(0.1)) // 设置整体背景色
            //                Spacer() // 把文本字段推向顶部
            
            
            
            //            Text("Likes")
            //                .tabItem {
            //                    Image(systemName: "heart.fill")
            //                    Text("Likes")
            //                }
            
            Text("我的")
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("我的")
                }
        }
            }
        
    }
   
struct PostView: View {
    var photoName: String

    var body: some View {
        ZStack{
            VStack(alignment: .leading, spacing: 0) {
                HStack {
                    Image("profile")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 50, height: 50)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.gray, lineWidth: 1))
                    
                    VStack(alignment: .leading) {
                        Text("username")
                            .font(.headline)
                        Text("location")
                            .font(.subheadline)
                    }
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.vertical, 8)
                
                Image(photoName)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                
                HStack(spacing: 20) {
                    Button(action: {}) {
                        Image(systemName: "heart")
                    }
                    
                    Button(action: {}) {
                        Image(systemName: "bubble.right")
                    }
                    
                    Button(action: {}) {
                        Image(systemName: "paperplane")
                    }
                    
                    Spacer()
                    
                    Button(action: {}) {
                        Image(systemName: "bookmark")
                    }
                }
                .padding(.horizontal)
                .padding(.vertical, 8)
                
                Text("Liked by user1, user2 and others")
                    .font(.footnote)
                    .padding(.horizontal)
                
                Text("View all comments")
                    .font(.footnote)
                    .foregroundColor(.gray)
                    .padding(.horizontal)
            }
        }
    }
}






#Preview {
    ContentView()
}

