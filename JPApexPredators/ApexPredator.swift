//
//  ApexPredator.swift
//  JPApexPredators
//
//  Created by 陳力聖 on 2025/10/10.
//

import Foundation
import MapKit
import SwiftUI

enum ApexPredatorType: String, Decodable, CaseIterable, Identifiable {
    case all, land, air, sea

    var id: ApexPredatorType {
        self
    }

    var backgroundColor: Color {
        switch self {
        case .land: .brown
        case .air: .teal
        case .sea: .blue
        case .all: .gray
        }
    }

    var icon: String {
        switch self {
        case .all: "square.stack.3d.up.fill"
        case .land: "leaf.fill"
        case .air: "wind"
        case .sea: "drop.fill"
        }
    }
}

struct ApexPredator: Decodable, Identifiable {
    let id: Int
    let name: String
    let type: ApexPredatorType
    let latitude: Double
    let longitude: Double
    let movies: [String]
    let movieScenes: [MovieScene]
    let link: String

    var image: String {
        name.lowercased().replacingOccurrences(of: " ", with: "")
    }

    var location: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }

    struct MovieScene: Decodable, Identifiable {
        let id: Int
        let movie: String
        let sceneDescription: String
    }
}
