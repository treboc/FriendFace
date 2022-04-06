//
//  UserListCell.swift
//  Friends
//
//  Created by Marvin Lee Kobert on 04.04.22.
//

import Inject
import SwiftUI

struct UserListCell: View {
  @ObservedObject private var iO = Inject.observer
  let user: User

  var body: some View {
    HStack(spacing: 10) {
      profileImage

      VStack(alignment: .leading) {
        Text(user.name)
          .padding(.bottom, 0)

        HStack {
          Text("Age \(user.age), works at \(user.company)")
            .font(.caption)
            .foregroundColor(.secondary)
        }

        HStack(spacing: 3) {
          Image(systemName: "calendar")
          Text("here since \(user.joined)")
        }
        .font(.caption)
        .foregroundColor(.secondary)
      }

      Spacer()

      isActiveIndicator
        .padding(.trailing)
    }
    .padding(.vertical, 10)
    .enableInjection()
  }

  private var profileImage: some View {
    ZStack {
      Circle()
        .fill(.background)
        .frame(width: 55, height: 55)
        .shadow(color: .black.opacity(0.5), radius: 5, x: 0, y: 0)

      AsyncImage(url: URL(string: "https://picsum.photos/200")) { image in
        image
          .resizable()
          .scaledToFit()
          .frame(width: 50, height: 50)
          .clipShape(Circle())
      } placeholder: {
        ZStack {
          Circle()
            .fill(.gray)
          ProgressView()
        }
      }
      .frame(width: 55, height: 55)
    }
  }

  private var isActiveIndicator: some View {
    Image(systemName: "circle.fill")
      .font(.caption)
      .foregroundColor(user.isActive ? .green : .red)
      .shadow(color: user.isActive ? .green : .red, radius: 5, x: 0, y: 0)
  }
}

struct Tag: View {
  let tagString: String
  let colors: [Color] = [.green, .red, .blue, .yellow, .purple, .pink]

  var body: some View {
    Text(tagString)
      .font(.caption2)
      .padding(.horizontal, 4)
      .background(
        Capsule()
          .fill(colors.randomElement()!)
      )
  }
}
