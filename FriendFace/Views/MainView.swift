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
  @StateObject private var viewModel: ViewModel = ViewModel() 

  var body: some View {
    NavigationView {
      List {
        ForEach(viewModel.users) { user in
          NavigationLink(destination: UserDetailView(user: user)) {
            UserListCell(user: user)
          }
          .onChange(of: viewModel.sortBy) { newValue in
            viewModel.sortUsers(by: newValue)
          }
        }
      }
      .listStyle(.inset)
      .navigationTitle("FriendFace")
      .toolbar {
        ToolbarItem(placement: .navigationBarTrailing) {
          toolbarFilterButton
        }
      }
    }
    .enableInjection()
  }

  private var toolbarFilterButton: some View {
    Menu {
      Picker("Sort by", selection: $viewModel.sortBy) {
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
