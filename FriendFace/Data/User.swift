//
//  User.swift
//  Friends
//
//  Created by Marvin Lee Kobert on 04.04.22.
//

import Foundation
import MapKit
import SwiftUI

struct User: Codable, Identifiable {
  struct Friend: Codable {
    let id: String
    let name: String
  }

  let id: String
  let isActive: Bool
  let name: String
  let age: Int
  let company: String
  let email: String
  let address: String
  let about: String
  let registered: Date
  let tags: [String]
  let friends: [Friend]

  var joined: String {
    let components = Calendar.current.dateComponents([.year, .month], from: registered)
    if let year = components.year, let month = components.month {
      let writtenMonth = Calendar.current.monthSymbols[month - 1]
      return "joined \(writtenMonth), \(year)"
    }
    return ""
  }
}
