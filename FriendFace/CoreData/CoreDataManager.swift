//
//  CoreDataManager.swift
//  FriendFace
//
//  Created by Marvin Lee Kobert on 06.04.22.
//
import CoreData
import Foundation

class DataController: ObservableObject {
  static let shared = DataController()

  let container = NSPersistentContainer(name: "FriendFace")

  init() {
    ValueTransformer.setValueTransformer(UIImageTransformer(), forName: NSValueTransformerName("UIImageTransformer"))

    container.loadPersistentStores { storeDescription, error in
      if let error = error {
        print("Core data failed to load: \(error.localizedDescription)")
      }
    }

    container.viewContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
  }

  func createUser(_ user: User) {
    let context = container.viewContext
    let newUser = CachedUser(context: context)
    newUser.id = user.id
    newUser.name = user.name
    newUser.address = user.address
    newUser.company = user.company
    newUser.isActive = user.isActive
    newUser.registered = user.registered
    newUser.about = user.about
    newUser.age = Int16(user.age)

    for friend in user.friends {
      let newFriend = CachedFriend(context: context)
      newFriend.id = friend.id
      newFriend.name = friend.name
      newUser.addToFriends(newFriend)
    }

    if context.hasChanges {
      do {
        try context.save()
        print("saved \(newUser.wrappedName)")
      } catch {
        print("Couldn't save user, \(error)")
      }
    }
  }
}
