//
//  OptionalImageView.swift
//  FriendFace
//
//  Created by Marvin Lee Kobert on 07.04.22.
//

import SwiftUI

struct OptionalImageView: View {
  let image: UIImage?

  var body: some View {
    if let image = image {
      Image(uiImage: image)
        .resizable()
        .scaledToFit()
        .frame(width: 50, height: 50)
        .clipShape(Circle())
    } else {
      ProgressView()
        .frame(width: 50, height: 50)
    }
  }
}
