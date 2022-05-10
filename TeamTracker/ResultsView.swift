//
//  ResultsView.swift
//  TeamTracker
//
//  Created by Harry Tidball on 04/03/2022.
//

import SwiftUI
import Foundation

struct ResultsView: View {
    
    var selectedID: Int
    var selectedName: String
    @State var venues = [String]()
    @State var leagues = [String]()
    @State var homeTeams = [String]()
    @State var awayTeams = [String]()
    @State var homeGoals = [Int]()
    @State var awayGoals = [Int]()
    @State var resultCount = Int()
    @State var resultsCount = [Int]()
    
    func fetchAPI() {

        let headers = [
            "X-RapidAPI-Host": "api-football-v1.p.rapidapi.com",
            "X-RapidAPI-Key": "a1b66724f6mshfd046763782d64cp14aaf9jsnea910e3d2e1c"
        ]

        let request = NSMutableURLRequest(url: NSURL(string: "https://api-football-v1.p.rapidapi.com/v3/fixtures?season=2021&team=" + String(selectedID) + "&last=25")! as URL,
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
                let resultCount = decoder.response.count - 1
                resultsCount.append(resultCount)
                for i in 0...resultCount {
                    venues.append(decoder.response[i].fixture?.venue?.name ?? "No Venue")
                    leagues.append(decoder.response[i].league?.name ?? "No League")
                    homeTeams.append(decoder.response[i].teams?.home?.name ?? "No Team")
                    awayTeams.append(decoder.response[i].teams?.away?.name ?? "No Team")
                    homeGoals.append(decoder.response[i].goals?.home ?? 0)
                    awayGoals.append(decoder.response[i].goals?.away ?? 0)
                }
            }
        })

        dataTask.resume()
    }
    
    var body: some View {
        GeometryReader { geometry in

        VStack (spacing: 0) {
            Text(selectedName + " Results")
                .onAppear {
                    if venues.count == 0 {
                    self.fetchAPI()
                        }
                    }
                .font(.title)
                .frame(width: geometry.size.width*0.8, height: geometry.size.height*0.0427)
                .scaledToFit()
                .minimumScaleFactor(0.01)
                .lineLimit(1)
                .foregroundColor(Color("Navy"))
                
            Spacer()
                .frame(height:
                        geometry.size.height*0.03)
            
            ScrollView () {
                if resultsCount.count == 1 {
            if awayGoals.count == resultsCount[0] + 1 {
            ForEach (0 ..< resultsCount[0] + 1) { i in
        HStack {
            VStack {
                HStack {
            Text(homeTeams[i])
                .foregroundColor(Color("Navy"))
                .font(.system(size: 16))
                .fontWeight(.semibold)
            Text(String(homeGoals[i]))
                .foregroundColor(Color("Navy"))
                .font(.system(size: 16))
                .fontWeight(.semibold)
            Text("-")
                .foregroundColor(Color("Navy"))
                .font(.system(size: 16))
                .fontWeight(.semibold)
            Text(String(awayGoals[i]))
                .foregroundColor(Color("Navy"))
                .font(.system(size: 16))
                .fontWeight(.semibold)
            Text(awayTeams[i])
                .foregroundColor(Color("Navy"))
                .font(.system(size: 16))
                .fontWeight(.semibold)
                }
                .scaledToFit()
                .minimumScaleFactor(0.01)
                .lineLimit(1)
            Text(venues[i])
                .foregroundColor(Color("Navy"))
                .font(.system(size: 14))
                .fontWeight(.medium)
            Text(leagues[i])
                .foregroundColor(Color("Navy"))
                .font(.system(size: 14))
            }
            .foregroundColor(Color("Navy"))
            .frame(width: geometry.size.width*0.8, height:
                    geometry.size.height*0.12)
            .scaledToFit()
            .minimumScaleFactor(0.01)
            .lineLimit(1)
            
        }
        .frame(width: geometry.size.width*0.8308, height:
                geometry.size.height*0.12)
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
    
    struct responseStruct: Decodable {
        let response: [fixturesStruct]
    }

    struct fixturesStruct: Decodable {
        let fixture: fixtureStruct?
        let league: leaguesStruct?
        let teams: teamsStruct?
        let goals: goalsStruct?
    }

    struct leaguesStruct: Decodable {
        let name: String?
    }

    struct fixtureStruct: Decodable {
        let venue: venueStruct?
    }

    struct teamsStruct: Decodable {
        let home: homeTeamStruct?
        let away: awayTeamStruct?
    }

    struct goalsStruct: Decodable {
        let home: Int?
        let away: Int?
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



struct ResultsView_Previews: PreviewProvider {
    static var previews: some View {
        ResultsView(selectedID: 0, selectedName: "")
        }
    }
}
