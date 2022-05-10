//
//  NewResultsView.swift
//  TeamTracker
//
//  Created by Harry Tidball on 25/03/2022.
//

import SwiftUI

struct NewResultsView: View {
    @Binding var selectedID: Int
    @Binding var selectedName: String
    
    init(selectedID: Binding<Int>, selectedName: Binding<String>) {
        UITabBar.appearance().isTranslucent = false
        self._selectedID = selectedID
        self._selectedName = selectedName
    }
    
    var body: some View {
        VStack {
        TabView {
            ResultsView(selectedID: selectedID, selectedName: selectedName)
                .tabItem {
                    Image(systemName: "house")
                    Text("Results")
                }
            FixturesView(selectedID: selectedID, selectedName: selectedName)
                .tabItem {
                    Image(systemName: "calendar")
                    Text("Fixtures")
                }
            StandingsView(selectedID: selectedID, selectedName: selectedName)
                .tabItem {
                    Image(systemName: "list.number")
                    Text("Standings")
                }
            SquadView(selectedID: selectedID, selectedName: selectedName)
                .tabItem {
                    Image(systemName: "person.3.fill")
                    Text("Squad")
                }
            
        }
        .accentColor(Color("Black"))
    }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color("Stone"))
    }
}

