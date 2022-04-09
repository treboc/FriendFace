//
//  UserDetailView.swift
//  Friends
//
//  Created by Marvin Lee Kobert on 04.04.22.
//

import Inject
import SwiftUI

struct UserDetailView: View {
  @ObservedObject private var iO = Inject.observer
  @Environment(\.dismiss) var dismiss
  @State private var showProfilePicture = false
  @State private var aboutIsShown = false
  @State private var isAnimating = false
  let user: CachedUser

  let tabs: [String] = ["Friends", "Follower"]
  @State private var chosenTab = ""

  var body: some View {
    ZStack(alignment: .top) {
      // BackgroundImage
      header

      VStack(alignment: .leading) {
        bioSection

        divider

        VStack(alignment: .leading) {
          HStack {
            ForEach(tabs, id: \.self) { tab in
              Text(tab)
                .font(.headline.bold())
                .if(tab == chosenTab, transform: { view in
                  view
                    .overlay(
                      Rectangle()
                        .fill(.orange)
                        .frame(height: 2)
                        .offset(x: 0, y: 10)
                    )
                })
                  .padding(.leading)
                  .onTapGesture {
                  withAnimation {
                    chosenTab = tab
                  }
                }
            }
          }

          if chosenTab == tabs[0] {
            ScrollView(.vertical, showsIndicators: false) {
              ForEach(user.friendsArray) { friend in
                FriendListCell(friend: friend)
              }
            }
            .frame(maxWidth: .infinity)
            .transition(.asymmetric(insertion: .move(edge: .leading), removal: .move(edge: .leading)))
          }

          if chosenTab == tabs[1] {
            ScrollView(.vertical, showsIndicators: false) {
              ForEach(user.friendsArray) { friend in
                FriendListCell(friend: friend)
              }
            }
            .frame(maxWidth: .infinity)
            .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .trailing)))
          }
        }

        Spacer()
      }
      .padding(.top, 50)
    }
    .if(showProfilePicture, transform: { view in
      view
        .overlay(
          ZStack {
            Color.white
              .ignoresSafeArea()

            Image(uiImage: ImageLoader.shared.profile!)
              .resizable()
              .scaledToFit()
              .frame(maxWidth: .infinity)
              .padding()
          }
        )
    })
      .enableLightStatusBar()
      .navigationBarBackButtonHidden(true)
      .navigationBarTitleDisplayMode(.inline)
      .toolbar {
      ToolbarItem(id: "backButton", placement: .navigationBarLeading, showsByDefault: true) {
        toolbarBackButton
      }
    }
    .onAppear { chosenTab = tabs.first! }
    .enableInjection()
  }
}

extension UserDetailView {
  private var header: some View {
    Group {
      if let image = ImageLoader.shared.header {
        Image(uiImage: image)
          .resizable()
          .scaledToFill()
          .frame(height: 150)
          .frame(maxWidth: .infinity)
          .clipped()
          .ignoresSafeArea()
      } else {
        Color.white
          .frame(height: 150)
          .frame(maxWidth: .infinity)
          .ignoresSafeArea()
      }
    }
  }

  private var bioSection: some View {
    VStack(alignment: .leading) {
      // Profile image, buttons
      HStack(spacing: 0) {
        profileImage
          .onTapGesture {
            withAnimation {
              showProfilePicture.toggle()
            }
          }

        Spacer()

        HStack {
          Circle()
            .strokeBorder(.secondary)
            .frame(width: 30, height: 30)
            .overlay(Image(systemName: "mustache.fill"))
            .padding(.top)

          Circle()
            .strokeBorder(.secondary)
            .frame(width: 30, height: 30)
            .overlay(Image(systemName: "bell.badge.fill"))
            .padding(.top)

          Capsule()
            .strokeBorder(.secondary)
            .frame(width: 90, height: 30)
            .overlay(Text("follow"))
            .padding(.top)
        }
      }

      // Name, address, joined
      VStack(alignment: .leading) {
        Text(user.wrappedName)
          .font(.headline.bold())

        HStack {
          Image(systemName: "house")
          Text("\(user.addressAsCityAndState)")
            .font(.subheadline)
        }
        .padding(.vertical, 1)

        HStack {
          Image(systemName: "calendar")
          Text(user.joined)
            .font(.subheadline)
        }
        .padding(.vertical, 1)
      }

      // About
      HStack {
        Text("About")
          .font(.callout.bold())
        Image(systemName: aboutIsShown ? "chevron.down" : "chevron.right")
          .font(.caption)
          .animation(.none, value: aboutIsShown)
      }
      .onTapGesture {
        withAnimation {
          aboutIsShown.toggle()
        }
      }

      if aboutIsShown {
        ScrollView {
          Text(user.wrappedAbout)
            .font(.callout)
            .padding(10)
        }
        .overlay(
          RoundedRectangle(cornerRadius: 10)
            .strokeBorder(.secondary)
        )
      }
    }
    .padding(.horizontal, 20)
  }

  private var profileImage: some View {
    ZStack {
      Circle()
        .fill(.background)
        .frame(width: 55, height: 55)

      if let image = ImageLoader.shared.profile {
        Image(uiImage: image)
          .resizable()
          .scaledToFit()
          .frame(width: 50, height: 50)
          .clipShape(Circle())
      }

    }
    .frame(width: 55, height: 55)
  }

  private var toolbarBackButton: some View {
    Button {
      withAnimation {
        if showProfilePicture {
          showProfilePicture = false
        } else {
          dismiss()
        }
      }
    } label: {
      Label(
        showProfilePicture ? "X" : "Back",
        systemImage: showProfilePicture ? "xmark" : "arrow.left"
      )
        .font(.headline)
        .foregroundColor(.primary)
        .padding(10)
        .background(
          Circle()
            .strokeBorder(showProfilePicture ? .black : .clear, lineWidth: 2)
            .background(Circle().fill(.background))
        )
    }
  }

  private var divider: some View {
    Rectangle()
      .fill(.secondary)
      .frame(height: 0.1)
      .frame(maxWidth: .infinity)
      .padding()
  }
}
