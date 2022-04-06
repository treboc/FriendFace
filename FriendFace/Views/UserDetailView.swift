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
  @State private var isAnimating = false
  let user: User

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
                        .fill(.red)
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
              ForEach(user.friends, id: \.name) { friend in
                FriendListCell(friend: friend)
              }
            }
            .frame(maxWidth: .infinity)
            .transition(.asymmetric(insertion: .move(edge: .leading), removal: .move(edge: .leading)))
          }

          if chosenTab == tabs[1] {
            ScrollView(.vertical, showsIndicators: false) {
              ForEach(user.friends, id: \.name) { friend in
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
            Color.red
              .ignoresSafeArea()


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
    AsyncImage(url: URL(string: "https://picsum.photos/900")) { image in
      image
        .resizable()
        .scaledToFill()
    } placeholder: {
      ZStack {
        Color.gray
        ProgressView()
      }
    }
    .frame(height: 150)
    .frame(maxWidth: .infinity)
    .clipped()
    .ignoresSafeArea()
  }

  private var bioSection: some View {
    VStack(alignment: .leading) {
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
      .padding(.horizontal, 20)

      VStack(alignment: .leading) {
        Text(user.name)
          .font(.headline.bold())

        HStack {
          Image(systemName: "house")
          Text("\(user.address)")
        }
        .font(.subheadline)
        .padding(.vertical, 1)

        HStack {
          Image(systemName: "calendar")
          Text(user.joined)
        }
        .font(.subheadline)
        .padding(.vertical, 1)
      }
     .padding(.leading, 20)
    }
  }

  private var profileImage: some View {
    ZStack {
      Circle()
        .fill(.background)
        .frame(width: 55, height: 55)

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
      Label(showProfilePicture ? "X" : "Back", systemImage: showProfilePicture ? "xmark" : "arrow.left")
        .font(.headline)
        .foregroundColor(.primary)
        .padding(10)
        .background(
          Circle()
            .fill(.background)
        )
        .animation(.default, value: showProfilePicture)
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
