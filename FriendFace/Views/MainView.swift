//
//  ContentView.swift
//  Friends
//
//  Created by Marvin Lee Kobert on 04.04.22.
//

import Inject
import SwiftUI

struct MainView: View {
  @ObservedObject private var iO = Inject.observer
  @StateObject private var dataController: ViewModel = ViewModel()

  var body: some View {
    NavigationView {
      List {
        ForEach(dataController.users) { user in
          NavigationLink(destination: UserDetailView(user: user)) {
            UserListCell(user: user)
          }
          .onChange(of: dataController.sortBy) { newValue in
            dataController.sortUsers(by: newValue)
          }
        }
      }
      .listStyle(.inset)
      .navigationTitle("FriendFace")
      .toolbar {
        ToolbarItem(placement: .navigationBarTrailing) {
          toolbarFilterItem
        }
      }
    }
    .enableInjection()
  }

  private var toolbarFilterItem: some View {
    Menu {
      Picker("Sort by", selection: $dataController.sortBy) {
        ForEach(ViewModel.SortingType.allCases, id: \.self) { item in
          Text(item.rawValue)
        }
      }
    } label: {
      Image(systemName: "arrow.up.arrow.down.circle")
    }
  }
}

#if DEBUG
struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    MainView()
  }
}
#endif
