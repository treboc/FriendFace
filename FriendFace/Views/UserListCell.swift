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
  @StateObject private var imageLoader = ImageLoader()
  @State private var isAnimated: Bool = false

  let user: CachedUser

  var body: some View {
    HStack(spacing: 10) {
      profileImage

      VStack(alignment: .leading) {
        Text(user.wrappedName)
          .padding(.bottom, 0)

        HStack {
          Text("Age \(user.age), works at \(user.wrappedCompany)")
            .font(.caption)
            .foregroundColor(.secondary)
        }

        HStack(spacing: 3) {
          Image(systemName: "calendar")
          Text("\(user.joined)")
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

      OptionalImageView(image: ImageLoader.shared.profile)
    }
  }

  private var isActiveIndicator: some View {
    Image(systemName: "circle.fill")
      .font(.caption)
      .foregroundColor(user.isActive ? .green : .red)
      .shadow(color: user.isActive ? .green : .red, radius: isAnimated ? 15 : 0, x: 0, y: 0)
      .onAppear {
        withAnimation(.easeInOut(duration: 0.7).repeatForever(autoreverses: false)) {
          isAnimated.toggle()
        }
      }
  }
}
