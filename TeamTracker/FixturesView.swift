//
//  FixturesView.swift
//  TeamTracker
//
//  Created by Harry Tidball on 11/03/2022.
//

import SwiftUI
import Foundation

struct FixturesView: View {
    
    var selectedID: Int
    var selectedName: String
    @State var venues = [String]()
    @State var leagues = [String]()
    @State var homeTeams = [String]()
    @State var awayTeams = [String]()
    @State var dates = [String]()
    @State var dateConverted = Date()
    @State var fixtureCount = Int()
    @State var fixturesCount = [Int]()
    
    func fetchAPI() {

        let headers = [
            "X-RapidAPI-Host": "api-football-v1.p.rapidapi.com",
            "X-RapidAPI-Key": "a1b66724f6mshfd046763782d64cp14aaf9jsnea910e3d2e1c"
        ]

        let request = NSMutableURLRequest(url: NSURL(string: "https://api-football-v1.p.rapidapi.com/v3/fixtures?season=2021&team=" + String(selectedID) + "&next=25")! as URL,
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
                let fixtureCount = decoder.response.count - 1
                fixturesCount.append(fixtureCount)
                for i in 0...fixtureCount {
                    venues.append(decoder.response[i].fixture.venue.name ?? "No Venue")
                    leagues.append(decoder.response[i].league.name ?? "No League")
                    homeTeams.append(decoder.response[i].teams.home.name ?? "No Team")
                    awayTeams.append(decoder.response[i].teams.away.name ?? "No Team")
                    dates.append(decoder.response[i].fixture.date ?? "No Date")
                }
            }
        })
        
        dataTask.resume()
        

    }
    
    var body: some View {
        GeometryReader { geometry in
                VStack (spacing:0) {
                Text("Upcoming Fixtures for " + selectedName)
                    .onAppear {
                        if venues.count == 0 {
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
                    
            if fixturesCount.count == 1 {
            if dates.count == fixturesCount[0] + 1 {
                ForEach (0 ..< fixturesCount[0] + 1) { i in
                    HStack {
                        VStack {
                            
                        Text(homeTeams[i] + " vs. " + awayTeams[i])
                                .font(.system(size: 16))
                                .fontWeight(.semibold)
                        Text(venues[i])
                                .font(.system(size:14))
                       
                        }
                        .foregroundColor(Color("Navy"))
                        
                        .frame(width: geometry.size.width*0.5, height:
                                geometry.size.height*0.1)
                        .scaledToFit()
                        .minimumScaleFactor(0.01)
                        .lineLimit(1)
                        
                        VStack {
                        let date = dates[i].prefix(10)
                        let day = date.suffix(2)
                        let noDay = date.prefix(7)
                        let month = noDay.suffix(2)
                        Text(day + "/" + month)
                        .fontWeight(.medium)
                        let time = dates[i].suffix(14)
                        Text(time.prefix(5))
                        .fontWeight(.medium)
                        }
                        .foregroundColor(Color("Navy"))
                        .font(.system(size: 16))
                        .frame(width: geometry.size.width*0.25)
                        .scaledToFit()
                        .minimumScaleFactor(0.01)
                        .lineLimit(1)
                        
                    }
                .frame(width: geometry.size.width*0.8308, height: geometry.size.height*0.12)
                .background(Color("Stone"))
                .padding(1)
                .background(Color("Navy"))
                        }
                    }
                }
            }
                .animation(.easeIn(duration:0.5))
        }
        .padding(.top)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color("Green"))
        }
    }
}

struct responseStruct: Decodable {
    let response: [fixturesStruct]
}

struct fixturesStruct: Decodable {
    let fixture: fixtureStruct
    let league: leaguesStruct
    let teams: teamsStruct
}

struct leaguesStruct: Decodable {
    let name: String?
}

struct fixtureStruct: Decodable {
    let venue: venueStruct
    let date: String?
}

struct teamsStruct: Decodable {
    let home: homeTeamStruct
    let away: awayTeamStruct
}

struct homeTeamStruct: Decodable {
    let name: String?
}

struct awayTeamStruct: Decodable {
    let name: String?
}

struct venueStruct: Decodable {
    let name: String?
}

struct FixturesView_Previews: PreviewProvider {
    static var previews: some View {
        FixturesView(selectedID: 0, selectedName: "")
    }
}
