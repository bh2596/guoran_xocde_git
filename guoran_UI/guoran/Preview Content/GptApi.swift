//
//  GptApi.swift
//  guoran
//
//  Created by Bowen on 4/20/24.
//

//import Foundation

//
//  GptApi.swift
//  gpttest1
//
//  Created by Bowen on 4/5/24.
//

import Foundation

//struct GptPrompt: Codable {
//    let prompt: String
//}

struct GptResponse: Codable {
    let image_url: String
}

class GptApi {
    let gptUrl = URL(string: "http://127.0.0.1:5000/gptapi")!
    
    
    
//    var request = URLRequest(url: gptUrl)
//    request.httpMethod = "POST"
    
//    func getImageUrl(completion:@escaping (GptResponse) -> ()) {
//        URLSession.shared.dataTask(with: gptUrl) { data,_,_  in
//            let joke = try! JSONDecoder().decode(GptResponse.self, from: data!)
//
//            DispatchQueue.main.async {
//                completion(joke)
//            }
//        }
//        .resume()
//    }
    
    func postImageUrl(promptText: String, completion:@escaping (GptResponse) -> ()) {
        var request = URLRequest(url: gptUrl);
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let body: [String: AnyHashable] = [
            "prompt": promptText
        ]
        print(body)
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: .fragmentsAllowed)
        print("shit here!!!!!!!")
        print (request.httpBody)
        URLSession.shared.dataTask(with: request) { data, response, error in
            // 检查是否有错误
            if let error = error {
                print("Request error: \(error.localizedDescription)")
                return
            }
            
            // 检查响应状态码是否在成功范围内
            if let httpResponse = response as? HTTPURLResponse, !(200...299).contains(httpResponse.statusCode) {
                print("Server error with status code: \(httpResponse.statusCode)")
                return
            }
            
            // 确保 data 不为 nil
            guard let data = data else {
                print("No data received")
                return
            }
            
            do {
                // 尝试解码数据
                let joke = try JSONDecoder().decode(GptResponse.self, from: data)
                print("jsonbody:", joke)

                // 打印请求体（确保请求体存在并且是可打印的）
                if let gpt_prompt = request.httpBody, let gptPromptString = String(data: gpt_prompt, encoding: .utf8) {
                    print(gptPromptString)
                }

                // 在主线程上调用 completion 处理
                DispatchQueue.main.async {
                    completion(joke)
                }
            } catch {
                // 处理 JSON 解码错误
                print("JSON decoding error: \(error.localizedDescription)")
            }
            
            
//            let joke = try JSONDecoder().decode(GptResponse.self, from: data)
//            // 将字节数据转换为JSON对象
//            do {
//                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
//                        // 读取"url"字段
//                        if let urlText = json["image_url"] as? String {
//                            print("URL: \(urlText)")
//                            // 在主线程上调用 completion 处理
//                        DispatchQueue.main.async {
//                            completion(urlText)}
//                        } else {
//                            print("Key 'url' not found in JSON")
//                        }
//                    } else {
//                        print("JSON format is invalid")
//                    }
//                } catch let error {
//                    print("Error parsing JSON: \(error.localizedDescription)")
//                }


            
//            print("response is", response)
//            print("data is", data)
//            
//            do {
//                // 尝试解码数据
//                let joke = try JSONDecoder().decode(GptResponse.self, from: data)
//                print("jsonbody:", joke)
//                
//                // 打印请求体（确保请求体存在并且是可打印的）
//                if let gpt_prompt = request.httpBody, let gptPromptString = String(data: gpt_prompt, encoding: .utf8) {
//                    print(gptPromptString)
//                }
//                
//                // 在主线程上调用 completion 处理
//                DispatchQueue.main.async {
//                    completion(joke)
//                }
//            } catch {
//                // 处理 JSON 解码错误
//                print("JSON decoding error: \(error.localizedDescription)")
//            }
        }.resume() // 别忘了调用 resume() 启动任务

//        URLSession.shared.dataTask(with: request) { data,_,_  in
//            print (data)
//            let joke = try! JSONDecoder().decode(GptResponse.self, from: data!)
//            var gpt_prompt = request.httpBody
//            print(gpt_prompt)
//            DispatchQueue.main.async {
//                completion(joke)
//            }
//        }
//        .resume()
    }
}

