//
//  DataController.swift
//  Friends
//
//  Created by Marvin Lee Kobert on 04.04.22.
//

import Combine
import Foundation
import SwiftUI

final class ViewModel: ObservableObject {
  @Published var users: [User] = []
  var cancellables = Set<AnyCancellable>()

  init() {
    getUsers()
  }

  func getUsers() {
    guard let url = URL(string: "https://www.hackingwithswift.com/samples/friendface.json") else {
      return
    }
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .iso8601

    URLSession.shared.dataTaskPublisher(for: url)
      .subscribe(on: DispatchQueue.global(qos: .background))
      .receive(on: DispatchQueue.main)
      .tryMap { (data, response) -> Data in
        guard
          let response = response as? HTTPURLResponse,
          response.statusCode >= 200 && response.statusCode < 300 else {
          throw URLError(.badServerResponse)
        }
        return data
      }
      .decode(type: [User].self, decoder: decoder)
      .sink { (completion) in
        print("COMPLETION: \(completion)")
      } receiveValue: { [weak self] (users) in
        self?.users = users
      }
      .store(in: &cancellables)
  }

  @Published var sortBy: SortingType = .byName

  enum SortingType: String, CaseIterable {
    case byName = "by Name"
    case isActive = "Active first"
  }

  func sortUsers(by sortingType: SortingType) {
    switch sortingType {
    case .byName:
      self.users.sort { $0.name < $1.name }
    case .isActive:
      self.users.sort { $0.isActive && !$1.isActive }
    }
  }
}
