//
//  ContentView.swift
//  TeamTracker
//
//  Created by Harry Tidball on 04/03/2022.
//

import SwiftUI
import Foundation

struct ContentView: View {
    @State var names = [String]()
    @State var logos = [String]()
    @State var ids = [Int]()
    @AppStorage("selectedID") var selectedID: Int = 0
    @AppStorage("selectedName") var selectedName: String = ""
    @State var button = false
    @State var isSelected = false
    @State var hasSelected = false
    
    init () {
        UINavigationBar.appearance().isTranslucent = true
    }
    
    func fetchAPI() {

        let headers = [
            "X-RapidAPI-Host": "api-football-v1.p.rapidapi.com",
            "X-RapidAPI-Key": "a1b66724f6mshfd046763782d64cp14aaf9jsnea910e3d2e1c"
        ]

        let request = NSMutableURLRequest(url: NSURL(string: "https://api-football-v1.p.rapidapi.com/v3/teams?league=39&season=2021")! as URL,
                                                cachePolicy: .useProtocolCachePolicy,
                                            timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers

        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                print(error)
            } else {
                let httpResponse = response as? HTTPURLResponse
                print(httpResponse)
            }
            if let decoder = try? JSONDecoder().decode(responseStruct.self, from: data!) {
                for i in 0...19 {
                    names.append(decoder.response[i].team.name)
                    ids.append(decoder.response[i].team.id)
                    logos.append(decoder.response[i].team.logo)

                }
            }
        })

        dataTask.resume()
        
        if selectedID > 0 {
            isSelected = true
        }
    }
    
    var body: some View {
        NavigationView {
        GeometryReader { geometry in
        VStack {
            Text("Select a Team to Follow")
                .onAppear {
                    if names.count == 0 {
                    self.fetchAPI()
                        }
                    }
                .foregroundColor(Color("Navy"))
                .font(.title)
                .frame(width: geometry.size.width*0.5795, height: geometry.size.height*0.0427)
                .scaledToFit()
                .minimumScaleFactor(0.01)
                .lineLimit(1)
                .padding(10)
                    
            if logos.count == 20 {
            ForEach (0 ..< 10) { i in
            HStack {
                Button(action: {
                    selectedID = ids[i]
                    selectedName = names[i]
                    hasSelected = true
                    button.toggle()
                    isSelected = true
                    
                }, label: {
                    Text(names[i])
                        .fontWeight(.medium)
                        .frame(width:geometry.size.width*0.25,
                               height:geometry.size.height*0.04)
                        .scaledToFit()
                        .minimumScaleFactor(0.01)
                        .lineLimit(1)
                        .foregroundColor((selectedName == names[i]) ? Color("Stone") : Color("Navy"))
                    if selectedName == names[i] {
                    AsyncImage(url: URL(string: logos[i])) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    } placeholder: {
                        Color("Navy")
                    }
                        .frame(width:geometry.size.width*0.07, height:geometry.size.height*0.04)
                    } else {
                        AsyncImage(url: URL(string: logos[i])) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                        } placeholder: {
                            Color("Stone")
                        }
                            .frame(width:geometry.size.width*0.07, height:geometry.size.height*0.04)
                    }
                }
                )
                    .animation(.easeIn(duration:0.5))
                    .foregroundColor(Color("Navy"))
                    .font(.system(size: 18))
                    .frame(width: geometry.size.width*0.4, height: geometry.size.height*0.0557)
                    .font(.system(size: 18))
                    .background((selectedName == names[i]) ? Color("Navy") : Color("Stone"))
                    .padding(1)
                    .background(Color("Navy"))
                
                Button(action: {
                    selectedID = ids[i+10]
                    selectedName = names[i+10]
                    button.toggle()
                    isSelected = true
                    hasSelected = true
                }, label: {
                    Text(names[i+10])
                        .fontWeight(.medium)
                        .frame(width:geometry.size.width*0.25,
                               height:geometry.size.height*0.04)
                        .animation(.easeIn(duration:0.5))
                        .scaledToFit()
                        .minimumScaleFactor(0.01)
                        .lineLimit(1)
                        .foregroundColor((selectedName == names[i+10]) ? Color("Stone") : Color("Navy"))
                    if selectedName == names[i+10] {
                    AsyncImage(url: URL(string: logos[i+10])) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    } placeholder: {
                        Color("Navy")
                    }
                        .frame(width:geometry.size.width*0.07, height:geometry.size.height*0.04)
                    } else {
                        AsyncImage(url: URL(string: logos[i+10])) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                        } placeholder: {
                            Color("Stone")
                        }
                            .frame(width:geometry.size.width*0.07, height:geometry.size.height*0.04)
                    }
                })
                    .animation(.easeIn(duration:0.5))
                    .foregroundColor(Color("Navy"))
                    .font(.system(size: 18))
                    .frame(width: geometry.size.width*0.4, height: geometry.size.height*0.0557)
                    .background((selectedName == names[i+10]) ? Color("Navy") : Color("Stone"))
                    .font(.system(size: 18))
                    .padding(1)
                    .background(Color("Navy"))
                    }
                }
            }
        
            NavigationLink(destination: NewResultsView(selectedID: self.$selectedID, selectedName: self.$selectedName)) {
                Text("Proceed")
                    .foregroundColor(Color("Stone"))
                    .font(.system(size: 18))
                    .frame(width: geometry.size.width*0.3128, height: geometry.size.height*0.0604)
                    .background((selectedID != 0) ? Color("Navy") : .gray)
                    .font(.system(size: 30))
                    .cornerRadius(30)
                    .padding(20)
                    .animation(hasSelected ? .easeOut(duration: 0.5) : nil)
            }.disabled(!isSelected)
            }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color("Green"))
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarTitle("Change Team")
        .navigationBarHidden(true)
        }

    }
    
    struct responseStruct: Decodable {
        let response: [teamsStruct]
    }

    struct teamsStruct: Decodable {
        let team: teamStruct
    }

    struct teamStruct: Decodable {
        let name: String
        let id: Int
        let logo: String
    }

    
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
        }
    }
}

