//
//  ContentView.swift
//  apitest
//
//  Created by Alberto Juarbe on 12/14/21.
//

import SwiftUI

struct WelcomeElement: Identifiable, Codable {
    let id: String?
    let fact: String
    let length: Int
}



class ApiTest: ObservableObject {
    
    @Published var uni: [WelcomeElement] = []
    
    init() {
        getPosts()
        
    }
    
    
    
    func getPosts() {
        
        guard let url = URL(string: "https://catfact.ninja/fact") else { return } //We got this url from /post1 from jsonplaceholder
        
        downloadData(fromURL: url) { (returnedData) in
            if let data = returnedData {
                guard let newPosts = try? JSONDecoder().decode(WelcomeElement.self, from: data) else { return }
                DispatchQueue.main.async { [weak self] in
                    self?.uni = [newPosts]
                    
                }
            }else {
                print("No data returned")
            }
        }
    }
    
    func downloadData(fromURL url: URL, completionHandler: @escaping (_ data: Data?) -> ()) {
        URLSession.shared.dataTask(with: url) { (data, response, error) in //Check if there is data, check if there is a response, check that there are no errors. This sets up the task. But it wont start until we get to resume
            //All the checks to ensure we have the data... Once the checks have been completed, you can merge like this:
            
         guard
            let data = data,
                error == nil,
                let response = response as? HTTPURLResponse,
            response.statusCode >= 200 && response.statusCode < 300 else {
                print("Error downloading data.")
                completionHandler(nil)
                return
            }
            
            completionHandler(data)
            
        }.resume()
    }
                          }



    
struct ContentView: View {
    
    @StateObject var univ = ApiTest()
    var body: some View {
        List {
            ForEach(univ.uni) { post in
                VStack(alignment: .leading) {
                    Text(post.fact)
                        .font(.headline)
                        .foregroundColor(.blue)
//                    Text(post.stateProvince ?? "")
//                        .font(.headline)
                    
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
