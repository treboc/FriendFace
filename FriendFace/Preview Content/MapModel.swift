//
//  MapModel.swift
//  Friends
//
//  Created by Marvin Lee Kobert on 04.04.22.
//

import Foundation
import MapKit

struct Adress: Codable {
  let data: [Datum]
}

struct Datum: Codable {
  let latitude, longitude: Double
  let name: String?
}

struct Location: Identifiable {
  let id = UUID()
  let name: String
  let coordinate: CLLocationCoordinate2D
}

class MapAPI: ObservableObject {
  private let BASE_URL = "http://api.positionstack.com/v1/forward"
  private let API_KEY = "ef8414b41e1e698429482ad034063153"

  static let shared = MapAPI()

  func getRegion(address: String, delta: Double = 5) -> MKCoordinateRegion? {
    let pAddress = address.replacingOccurrences(of: " ", with: "%20")
    let urlString = "\(BASE_URL)?access_key=\(API_KEY)&query=\(pAddress)"
    var region: MKCoordinateRegion?

    guard let url = URL(string: urlString) else {
      print("Invalid URL")
      return nil
    }

    URLSession.shared.dataTask(with: url) { (data, response, error) in
      guard let data = data else {
        print(error!.localizedDescription)
        return
      }

      guard let newCoordinates = try? JSONDecoder().decode(Adress.self, from: data) else { return }

      if newCoordinates.data.isEmpty {
        print("Could not find the adress.")
        return
      }

      DispatchQueue.main.async {
        let detail = newCoordinates.data[0]
        let lat = detail.latitude
        let lon = detail.longitude
        let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lon)
        region = MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: delta, longitudeDelta: delta))
        print(region?.center)
      }
    }
    .resume()

    return region
  }
}
