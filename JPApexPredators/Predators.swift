//
//  Predators.swift
//  JPApexPredators
//
//  Created by 陳力聖 on 2025/10/10.
//

import FirebaseAnalytics
import Foundation

class Predators {
    var allApexPredators: [ApexPredator] = []
    var apexPredators: [ApexPredator] = []

    init() {
        decodeApexPredatorData()
        let deviceId = UIDevice.current.identifierForVendor?.uuidString
        print("user device id: \(deviceId ?? "unknown")")
        Analytics.logEvent(AnalyticsEventSelectContent, parameters: [
            AnalyticsParameterItemID: "id-\(deviceId!)",
            AnalyticsParameterItemName: deviceId!,
            AnalyticsParameterContentType: "cont"
        ])
    }

    func decodeApexPredatorData() {
        if let url = Bundle.main.url(
            forResource: "jpapexpredators",
            withExtension: "json"
        ) {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                allApexPredators = try decoder.decode(
                    [ApexPredator].self,
                    from: data
                )
            } catch {
                print("Error decoding JSON data: \(error)")
            }
        }
    }

    func search(by searchText: String) -> [ApexPredator] {
        let filtered = apexPredators.filter { predator in
            predator.name.localizedCaseInsensitiveContains(searchText)
        }
        return filtered.isEmpty ? apexPredators : filtered
    }

    func sort(by alphabetical: Bool) {
        apexPredators
            .sort(by: { alphabetical ? $0.name < $1.name : $0.id < $1.id })
    }

    func filter(by type: ApexPredatorType) {
        if type == ApexPredatorType.all {
            apexPredators = allApexPredators
        } else {
            apexPredators = allApexPredators.filter { predator in
                predator.type == type
            }
        }
    }
}
