//
//  LightStatusbarModifier.swift
//  Friends
//
//  Created by Marvin Lee Kobert on 05.04.22.
//

import Foundation
import SwiftUI

struct LightStatusBarModifier: ViewModifier {
  func body(content: Content) -> some View {
    content
      .onAppear {
        UIApplication.shared.statusBarStyle = .lightContent
      }
      .onDisappear {
        UIApplication.shared.statusBarStyle = .default
      }
  }
}

extension View {
  func enableLightStatusBar() -> some View {
    self.modifier(LightStatusBarModifier())
  }
}


