//
//  StandingsView.swift
//  TeamTracker
//
//  Created by Harry Tidball on 11/03/2022.
//

import SwiftUI
import Foundation


struct StandingsView: View {
    
    var selectedID: Int
    var selectedName: String
    @State var league = String()
    @State var ranks = [Int]()
    @State var names = [String]()
    @State var logos = [String]()
    @State var points = [Int]()
    @State var goalDifferences = [Int]()
    @State var wins = [Int]()
    @State var draws = [Int]()
    @State var losses = [Int]()
    @State private var isSelected = false

    func fetchAPI() {

        let headers = [
            "X-RapidAPI-Host": "api-football-v1.p.rapidapi.com",
            "X-RapidAPI-Key": "a1b66724f6mshfd046763782d64cp14aaf9jsnea910e3d2e1c"
        ]

        let request = NSMutableURLRequest(url: NSURL(string: "https://api-football-v1.p.rapidapi.com/v3/standings?season=2021&league=39")! as URL,
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
                self.league = decoder.response[0].league.name
                for i in 0...19 {
                    ranks.append(decoder.response[0].league.standings[0][i].rank)
                    points.append(decoder.response[0].league.standings[0][i].points)
                    goalDifferences.append(decoder.response[0].league.standings[0][i].goalsDiff)
                    names.append(decoder.response[0].league.standings[0][i].team.name)
                    logos.append(decoder.response[0].league.standings[0][i].team.logo)
                    wins.append(decoder.response[0].league.standings[0][i].all.win)
                    draws.append(decoder.response[0].league.standings[0][i].all.draw)
                    losses.append(decoder.response[0].league.standings[0][i].all.lose)
                }
            }
        })

        dataTask.resume()
    }

    
    var body: some View {
        GeometryReader { geometry in
        VStack {
            Text("Premier League Table")
                .foregroundColor(Color("Navy"))
                .font(.title)
                .frame(width: geometry.size.width*0.5795, height: geometry.size.height*0.0427)
                .scaledToFit()
                .minimumScaleFactor(0.01)
                .lineLimit(1)
                .onAppear {
                    if ranks.count == 0 {
                        self.fetchAPI()
                    }
                    }
            
            Spacer()
                .frame(height:
                        geometry.size.height*0.03)

            ScrollView(showsIndicators: false) {
            VStack (spacing:0) {
                if losses.count == 20 {
                HStack() {
                    VStack() {
                    Text("")
                        .frame(width: geometry.size.width*0.0641, height: geometry.size.height*0.06)
                    ForEach (0 ..< 20) { i in
                        Text(String(ranks[i]))
                            .fontWeight(.semibold)
                            .frame(width: geometry.size.width*0.0641, height: geometry.size.height*0.06)
                            .foregroundColor((selectedName == names[i]) ? Color.red : Color("Navy"))
                    }
                    }

                    
                    VStack() {
                    Text("")
                        .frame(width: geometry.size.width*0.0641, height: geometry.size.height*0.06)
                    ForEach (0 ..< 20) { i in
                        AsyncImage(url: URL(string: logos[i])) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                        } placeholder: {
                            Color("Stone")
                        }
                            .frame(width: geometry.size.width*0.05, height: geometry.size.height*0.06)
                    }
                    }
                    .animation(.easeIn(duration:0.5))
                    
                    
                    VStack() {
                    Text("")
                        .frame(width: geometry.size.width*0.0641, height: geometry.size.height*0.06)
                    ForEach (0 ..< 20) { i in
                        Text(String(names[i]))
                            .fontWeight(.medium)
                            .frame(width: geometry.size.width*0.325, height: geometry.size.height*0.06)
                            .scaledToFit()
                            .minimumScaleFactor(0.01)
                            .lineLimit(1)
                            .foregroundColor((selectedName == names[i]) ? Color.red : Color("Navy"))
                    }
                    }
                    
                    
                    VStack() {
                    Text("W")
                        .fontWeight(.semibold)
                        .frame(width: geometry.size.width*0.0641, height: geometry.size.height*0.06)
                    ForEach (0 ..< 20) { i in
                        Text(String(wins[i]))
                            .frame(width: geometry.size.width*0.0641, height: geometry.size.height*0.06)
                            .scaledToFit()
                            .minimumScaleFactor(0.01)
                            .lineLimit(1)
                            .foregroundColor((selectedName == names[i]) ? Color.red : Color("Navy"))
                    }
                    }
                    
                    
                    VStack() {
                    Text("D")
                        .fontWeight(.semibold)
                        .frame(width: geometry.size.width*0.0641, height: geometry.size.height*0.06)
                    ForEach (0 ..< 20) { i in
                        Text(String(draws[i]))
                            .frame(width: geometry.size.width*0.0641, height: geometry.size.height*0.06)
                            .scaledToFit()
                            .minimumScaleFactor(0.01)
                            .lineLimit(1)
                            .foregroundColor((selectedName == names[i]) ? Color.red : Color("Navy"))
                    }
                    }
                   
                    
                    VStack() {
                    Text("L")
                        .fontWeight(.semibold)
                        .frame(width: geometry.size.width*0.0641, height: geometry.size.height*0.06)
                    ForEach (0 ..< 20) { i in
                        Text(String(losses[i]))
                            .frame(width: geometry.size.width*0.0641, height: geometry.size.height*0.06)
                            .scaledToFit()
                            .minimumScaleFactor(0.01)
                            .lineLimit(1)
                            .foregroundColor((selectedName == names[i]) ? Color.red : Color("Navy"))
                    }
                    }
                    
                    
                    VStack() {
                    Text("G/D")
                        .fontWeight(.semibold)
                        .frame(width: geometry.size.width*0.0641, height: geometry.size.height*0.06)
                        .scaledToFit()
                        .minimumScaleFactor(0.01)
                        .lineLimit(1)
                    ForEach (0 ..< 20) { i in
                        Text(String(goalDifferences[i]))
                            .frame(width: geometry.size.width*0.0641, height: geometry.size.height*0.06)
                            .scaledToFit()
                            .minimumScaleFactor(0.01)
                            .lineLimit(1)
                            .foregroundColor((selectedName == names[i]) ? Color.red : Color("Navy"))
                    }
                    }
                    
                    
                    VStack() {
                    Text("P")
                        .fontWeight(.semibold)
                        .frame(width: geometry.size.width*0.0641, height: geometry.size.height*0.06)
                    ForEach (0 ..< 20) { i in
                        Text(String(points[i]))
                            .fontWeight(.semibold)
                            .frame(width: geometry.size.width*0.075, height: geometry.size.height*0.06)
                            .scaledToFit()
                            .minimumScaleFactor(0.01)
                            .lineLimit(1)
                            .foregroundColor((selectedName == names[i]) ? Color.red : Color("Navy"))
                    }
                    }
                    
                    

                }  .frame(width: geometry.size.width*0.94)
                        .padding(.bottom)
                        .padding(.top, 3.5)
                        .foregroundColor(Color("Navy"))
                        .background(Color("Stone"))
                    
                }

            }       .padding(1)
                .background(Color("Navy"))}
            .font(.system(size: 17))

        }
        .padding(.top)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color("Green"))
            
        }
    }


struct responseStruct: Decodable {
    let response: [leaguesStruct]
}

struct leaguesStruct: Decodable {
    let league: leagueStruct
}
    
struct leagueStruct: Decodable {
    let name: String
    let standings: [[standingsStruct]]
}
    
struct standingsStruct: Decodable {
    let rank: Int
    let points: Int
    let goalsDiff: Int
    let team: teamsStruct
    let all: allStruct
}
    
struct teamsStruct: Decodable {
    let name: String
    let logo: String
}
    
struct allStruct: Decodable {
    let win: Int
    let draw: Int
    let lose: Int
}

struct StandingsView_Previews: PreviewProvider {
    static var previews: some View {
        StandingsView(selectedID: 0, selectedName: "")
    }
}

}
