//
//  ContentView.swift
//  JPApexPredators
//
//  Created by 陳力聖 on 2025/10/10.
//

import MapKit
import SwiftUI

struct ContentView: View {
    let predators = Predators()
    @State var searchText: String = ""
    @State var alphabetical: Bool = false
    @State var currentType: ApexPredatorType = .all

    var filterdDinos: [ApexPredator] {
        predators.filter(by: currentType)
        predators.sort(by: alphabetical)
        return predators.search(by: searchText)
    }

    var body: some View {
        NavigationStack {
            List(filterdDinos) { predator in
                NavigationLink {
                    PredatorDetail(
                        preditor: predator,
                        position: .camera(MapCamera(
                            centerCoordinate: predator.location,
                            distance: 30000
                        ))
                    )
                } label: {
                    HStack {
                        Image(
                            predator.image
                        ).resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                            .shadow(color: .white, radius: 1)

                        VStack(alignment: .leading) {
                            Text(predator.name)
                                .fontWeight(.bold)

                            Text(predator.type.rawValue.capitalized)
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .padding(.horizontal, 13)
                                .padding(.vertical, 5)
                                .background(predator.type.backgroundColor)
                                .clipShape(.capsule)
                        }
                    }
                }
            }
            .navigationTitle("Apex Predators")
            .searchable(
                text: $searchText,
                prompt: Text(Bundle.main
                    .infoDictionary?["API_URL"] as? String ?? "Search")
            )
            .autocorrectionDisabled()
            .animation(.default, value: searchText)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        withAnimation {
                            alphabetical.toggle()
                        }
                    } label: {
                        Image(systemName: alphabetical ? "film" : "textformat")
                            .symbolEffect(.bounce, value: alphabetical)
                    }
                }

                ToolbarItem(placement: .topBarTrailing) {
                    Menu {
                        Picker("Filter", selection: $currentType.animation()) {
                            ForEach(ApexPredatorType.allCases) { type in
                                Label(
                                    type.rawValue.capitalized,
                                    systemImage: type.icon
                                )
                            }
                        }
                    } label: {
                        Image(systemName: "slider.horizontal.3")
                    }
                }
            }
        }
        .preferredColorScheme(.dark)
    }
}

#Preview {
    ContentView()
}
