//
//  FriendListCell.swift
//  Friends
//
//  Created by Marvin Lee Kobert on 06.04.22.
//

import SwiftUI

struct FriendListCell: View {
  let friend: User.Friend

  private var profileImage: some View {
    ZStack {
      Circle()
        .fill(.background)
        .frame(width: 45, height: 45)
        .shadow(color: .black.opacity(0.5), radius: 5, x: 0, y: 0)

      AsyncImage(url: URL(string: "https://picsum.photos/200")) { image in
        image
          .resizable()
          .scaledToFit()
          .frame(width: 40, height: 40)
          .clipShape(Circle())
      } placeholder: {
        ZStack {
          Circle()
            .fill(.gray)
          ProgressView()
        }
      }
    }
  }

  var body: some View {
    HStack(alignment: .center, spacing: 10) {
      profileImage
      Text(friend.name)
      Spacer()
    }
    .frame(height: 50)
    .padding(.horizontal)
    .padding(.vertical, 4)
  }
}
