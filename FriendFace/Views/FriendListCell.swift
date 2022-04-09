//
//  FriendListCell.swift
//  Friends
//
//  Created by Marvin Lee Kobert on 06.04.22.
//

import SwiftUI

struct FriendListCell: View {
  let friend: CachedFriend

  private var profileImage: some View {
    ZStack {
      Circle()
        .fill(.background)
        .frame(width: 45, height: 45)
        .shadow(color: .black.opacity(0.5), radius: 5, x: 0, y: 0)

      OptionalImageView(image: ImageLoader.shared.profile)
    }
  }

  var body: some View {
    HStack(alignment: .center, spacing: 10) {
      profileImage
      Text(friend.wrappedName)
      Spacer()
    }
    .frame(height: 50)
    .padding(.horizontal)
    .padding(.vertical, 4)
  }
}
