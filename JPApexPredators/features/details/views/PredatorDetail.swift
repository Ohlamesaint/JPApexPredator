//
//  details.swift
//  JPApexPredators
//
//  Created by 陳力聖 on 2025/10/10.
//

import MapKit
import SwiftUI

struct PredatorDetail: View {
    let preditor: ApexPredator
    @State var position: MapCameraPosition
    @Namespace var namespace
    var body: some View {
        GeometryReader { geo in
            ScrollView {
                ZStack(alignment: .bottomTrailing) {
                    // Background Image
                    Image(preditor.type.rawValue)
                        .resizable()
                        .scaledToFit()
                        .overlay {
                            LinearGradient(stops: [
                                Gradient.Stop(color: .clear, location: 0.8),
                                Gradient.Stop(color: .black, location: 1.0),
                            ], startPoint: .top, endPoint: .bottom)
                        }
                    // Dinasour Image
                    Image(preditor.image)
                        .resizable()
                        .scaledToFit()
                        .frame(
                            width: geo.size.width / 1.5,
                            height: geo.size.height / 3.7
                        )
                        .scaleEffect(x: -1)
                        .shadow(color: .white, radius: 7)
                        .offset(y: 20)
                }
                VStack(alignment: .leading) {
                    Button("Crash") {
                        fatalError("Crash was triggered")
                    }
                    // Dino Name
                    Text(preditor.name)
                        .font(.largeTitle)
                    // Current Location
                    NavigationLink {
                        PredatorMap(defaultPosition: .camera(MapCamera(
                            centerCoordinate: preditor.location,
                            distance: 1000,
                            heading: 250,
                            pitch: 80
                        )))
                        .navigationTransition(.zoom(
                            sourceID: 1,
                            in: namespace
                        ))
                    } label: {
                        Map(position: $position) {
                            Annotation(
                                preditor.name,
                                coordinate: preditor.location,
                                anchor: .center
                            ) {
                                Image(systemName: "mappin.and.ellipse")
                                    .font(.largeTitle)
                                    .imageScale(.large)
                                    .symbolEffect(.pulse)
                            }
                            .annotationTitles(.hidden)
                        }
                        .frame(height: 125)
                        .allowsHitTesting(false)
                        .overlay(alignment: .trailing) {
                            Image(systemName: "greaterthan")
                                .imageScale(.large)
                                .font(.title3)
                                .padding(.trailing, 5)
                        }
                        .overlay(alignment: .topLeading) {
                            Text("Current Location")
                                .font(.title3)
                                .padding([.leading, .bottom], 5)
                                .padding(.trailing, 8)
                                .background(.black.opacity(0.33))
                                .clipShape(.rect(bottomTrailingRadius: 15))
                        }
                        .clipShape(.rect(cornerRadius: 15))
                    }
                    .matchedTransitionSource(id: 1, in: namespace)

                    // Appears in
                    Text("Appears in:")
                        .font(.title3)
                        .padding(.top)

                    ForEach(preditor.movies, id: \.self) { movie in
                        Text("• " + movie)
                            .font(.subheadline)
                    }
                    // Movie comments
                    Text("Movie moments: ")
                        .font(.title)
                        .padding(.top, 15)

                    ForEach(preditor.movieScenes) { movieScene in
                        Text(movieScene.movie)
                            .font(.title2)
                            .padding(.vertical, 1)

                        Text(movieScene.sceneDescription)
                            .padding(.bottom, 15)
                    }

                    // Link to webpage
                    Text("Read More: ")
                        .font(.caption)

                    Link(preditor.link,
                         destination: URL(string: preditor.link)!).font(
                        .caption
                    )
                    .foregroundStyle(.link)
                }
                .padding()
                .padding(.bottom)
                .frame(width: geo.size.width, alignment: .leading)
            }
            .ignoresSafeArea()
            .toolbarBackground(.automatic)
        }
    }
}

#Preview {
    let predator = Predators().allApexPredators[2]
    NavigationStack {
        PredatorDetail(
            preditor: predator,
            position: .camera(MapCamera(
                centerCoordinate: predator.location,
                distance: 30000
            ))
        )
    }
}
