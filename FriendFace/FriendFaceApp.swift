//
//  FriendsApp.swift
//  Friends
//
//  Created by Marvin Lee Kobert on 04.04.22.
//

import SwiftUI

@main
struct FriendFaceApp: App {
  var body: some Scene {
    WindowGroup {
      MainView()
        .onAppear {
          UserDefaults.standard.setValue(false, forKey: "_UIConstraintBasedLayoutLogUnsatisfiable")
        }
    }
  }
}
