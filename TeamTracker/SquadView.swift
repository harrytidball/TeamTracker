//
//  SquadView.swift
//  TeamTracker
//
//  Created by Harry Tidball on 11/03/2022.
//

import SwiftUI
import Foundation

struct SquadView: View {
    
    var selectedID: Int
    var selectedName: String
    @State var names = [String]()
    @State var ages = [Int]()
    @State var positions = [String]()
    @State var photos = [String]()
    @State var playerCount = Int()
    @State var playersCount = [Int]()
    
    func fetchAPI() {

        let headers = [
            "X-RapidAPI-Host": "api-football-v1.p.rapidapi.com",
            "X-RapidAPI-Key": "a1b66724f6mshfd046763782d64cp14aaf9jsnea910e3d2e1c"
        ]

        let request = NSMutableURLRequest(url: NSURL(string: "https://api-football-v1.p.rapidapi.com/v3/players/squads?team=" + String(selectedID))! as URL,
                                                cachePolicy: .useProtocolCachePolicy,
                                            timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers

        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error == nil) {
                print(error)
            } else {
                let httpResponse = response as? HTTPURLResponse
                print(httpResponse)
            }
            if let decoder = try? JSONDecoder().decode(responseStruct.self, from: data!) {
                let playerCount = decoder.response[0].players.count - 1
                playersCount.append(playerCount)
                for i in 0...playerCount {
                    names.append(decoder.response[0].players[i].name ?? "No Name")
                    ages.append(decoder.response[0].players[i].age ?? 22)
                    positions.append(decoder.response[0].players[i].position ?? "No Position")
                    photos.append(decoder.response[0].players[i].photo ?? "No Photo")
                }
            }
        })

        dataTask.resume()
    }
    
    
    var body: some View {
        
        GeometryReader { geometry in
        VStack (spacing:0) {
            Text(selectedName + " Squad")
                .onAppear {
                    if names.count == 0 {
                    self.fetchAPI()
                    }
                }
                .foregroundColor(Color("Navy"))
                .font(.title)
                .frame(width: geometry.size.width*0.8, height: geometry.size.height*0.0427)
                .scaledToFit()
                .minimumScaleFactor(0.01)
                .lineLimit(1)
            
            Spacer()
                .frame(height:
                        geometry.size.height*0.03)

            ScrollView () {
                VStack (spacing:0) {
                    
        if playersCount.count == 1 {
        if photos.count == playersCount[0] + 1 {
            ForEach (0 ..< playersCount[0] + 1) { i in
                HStack {
                    VStack {
                        
                    Text(names[i])
                    .fontWeight(.semibold)
                    Text("Age: " + String(ages[i]))
                    .fontWeight(.medium)
                   
                    }
                    .foregroundColor(Color("Navy"))
                    .font(.system(size: 16))
                    .frame(width: geometry.size.width*0.3)
                    .scaledToFit()
                    .minimumScaleFactor(0.01)
                    .lineLimit(1)
                    
                    VStack {
                    Text(positions[i])
                    .fontWeight(.medium)
                    }
                    .foregroundColor(Color("Navy"))
                    .font(.system(size: 16))
                    .frame(width: geometry.size.width*0.25)
                    
                    VStack {
                    AsyncImage(url: URL(string: photos[i])) { photo in
                        photo
                            .resizable()
                            .scaledToFit()
                            .minimumScaleFactor(0.01)
                            .lineLimit(1)
                            .padding(1)
                            .background(Color("Navy"))
                            .aspectRatio(contentMode: .fill)
                                                } placeholder: {
                        Color("Stone")
                    }
                        .frame(width: geometry.size.width*0.1436, height: geometry.size.height*0.0699)
                        
                    }
                    .animation(.easeIn(duration:0.5))
                    .frame(width: geometry.size.width*0.2)
                }
                .frame(width: geometry.size.width*0.8308, height: geometry.size.height*0.1)
                .background(Color("Stone"))
                .padding(1)
                .background(Color("Navy"))
                Spacer()

            }
            
            .background(Color("Stone"))
        }
            }
            }
        }
        }
        .padding(.top)
        .frame(width: geometry.size.width, height: geometry.size.height)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color("Green"))
            
        }

    }


    struct responseStruct: Decodable {
        let response: [squadsStruct]
    }

    struct squadsStruct: Decodable {
        let players: [playersStruct]
    }
        
    struct playersStruct: Decodable {
        let name: String?
        let age: Int?
        let position: String?
        let photo: String?
    }
    

struct SquadView_Previews: PreviewProvider {
    static var previews: some View {
        SquadView(selectedID: 0, selectedName: "")
    }
}
}
