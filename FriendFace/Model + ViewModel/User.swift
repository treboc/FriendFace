//
//  User.swift
//  Friends
//
//  Created by Marvin Lee Kobert on 04.04.22.
//

import Foundation
import MapKit
import SwiftUI

struct Friend: Codable, Identifiable {
  let id: String
  let name: String
}

struct User: Codable, Identifiable {
  let id: String
  let isActive: Bool
  let name: String
  let age: Int
  let company: String
  let address: String
  let about: String
  let registered: Date
  let friends: [Friend]
  //  let tags: [String]
  //  let email: String
}
