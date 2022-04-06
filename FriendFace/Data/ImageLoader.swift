//
//  ImageLoader.swift
//  FriendFace
//
//  Created by Marvin Lee Kobert on 06.04.22.
//

import SwiftUI
import Combine
import Foundation

class ImageLoader: ObservableObject {
  @Published var images: [UIImage] = []
  private let url = URL(string: "https://picsum.photos/200")!
  private var cancellable: AnyCancellable?

  deinit {
    cancel()
  }

  func load() {
    if images.isEmpty {
//      for _ in 0..<10 {
        cancellable = URLSession.shared.dataTaskPublisher(for: url)
          .map { UIImage(data: $0.data) }
          .replaceError(with: nil)
          .receive(on: DispatchQueue.main)
          .sink { [weak self] in self?.images.append($0!) }
//      }
    }
  }

  func cancel() {
    cancellable?.cancel()
  }
}

struct AsyncImage2<Placeholder: View>: View {
  @StateObject private var loader: ImageLoader
  private let placeholder: Placeholder

  init(@ViewBuilder placeholder: () -> Placeholder) {
    self.placeholder = placeholder()
    _loader = StateObject(wrappedValue: ImageLoader())
  }

  var body: some View {
    content
      .onAppear(perform: loader.load)
  }

  private var content: some View {
    Group {
      if loader.images.count != 0 {
        Image(uiImage: loader.images.randomElement()!)
          .resizable()
      } else {
        placeholder
      }
    }
  }
}
