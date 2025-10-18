//
//  PredatorMap.swift
//  JPApexPredators
//
//  Created by 陳力聖 on 2025/10/10.
//

import Foundation
import MapKit
import SwiftUI

struct PredatorMap: View {
    let predators: Predators = .init()
    @State var defaultPosition: MapCameraPosition
    @State var satelite: Bool = false

    var body: some View {
        Map(position: $defaultPosition) {
            ForEach(predators.allApexPredators) { predator in
                Annotation(predator.name, coordinate: predator.location) {
                    Image(predator.image)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 100)
                        .shadow(color: .white, radius: 3)
                        .scaleEffect(x: -1)
                }.annotationTitles(.hidden)
            }
        }
        .mapStyle(satelite ? .imagery(elevation: .realistic) :
            .standard(elevation: .realistic))
        .overlay(alignment: .bottomTrailing) {
            Button {
                satelite.toggle()
            } label: {
                Image(systemName: satelite ? "globe.americas.fill" :
                    "globe.americas")
                    .font(.largeTitle)
                    .imageScale(.large)
                    .padding(3)
                    .background(.ultraThinMaterial)
                    .clipShape(.rect(cornerRadius: 7))
                    .shadow(radius: 3)
                    .padding()
            }
        }.toolbarBackground(.automatic)
    }
}

#Preview {
    let allApexPredators = Predators().allApexPredators

    let position: MapCameraPosition = .camera(
        MapCamera(centerCoordinate: allApexPredators[2].location,
                  distance: 1000,
                  heading: 250,
                  pitch: 80)
    )

    return PredatorMap(
        defaultPosition: position
    )
    .preferredColorScheme(.dark)
}
