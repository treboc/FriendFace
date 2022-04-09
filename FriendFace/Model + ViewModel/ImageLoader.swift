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
  static let shared = ImageLoader()

  @Published var header: UIImage?
  @Published var profile: UIImage?

  private var cancellable: AnyCancellable?

  init() {
    loadAllImages()
  }

  deinit {
    cancel()
  }

  enum ImageType: String {
    case header = "https://picsum.photos/900"
    case profile = "https://picsum.photos/id/212/200"
  }

  func loadAllImages() {
    load(.profile)
    load(.header)
  }

  func load(_ imageType: ImageType) {
    if let image = ImageCache.shared.getImage(for: imageType.rawValue) {
      switch imageType {
      case .header:
        self.header = image
      case .profile:
        self.profile = image
      }
    } else {
      guard let url = URL(string: imageType.rawValue) else {
        return
      }
      cancellable = URLSession.shared.dataTaskPublisher(for: url)
        .map { UIImage(data: $0.data) }
        .replaceError(with: nil)
        .subscribe(on: DispatchQueue.global(qos: .background))
        .receive(on: DispatchQueue.main)
        .sink { [weak self] in
          switch imageType {
          case .header:
            self?.header = $0!
          case .profile:
            self?.profile = $0!
          }
          ImageCache.shared.cache($0!, for: imageType.rawValue)
        }
    }
  }
  
  func cancel() {
    cancellable?.cancel()
  }
}

final class ImageCache: NSCache<NSString, UIImage> {
  static let shared = ImageCache()

  func cache(_ image: UIImage, for key: String) {
    self.setObject(image, forKey: key as NSString)
  }

  func getImage(for key: String) -> UIImage? {
    self.object(forKey: key as NSString)
  }
}
