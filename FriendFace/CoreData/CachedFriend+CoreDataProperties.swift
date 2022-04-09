//
//  CachedFriend+CoreDataProperties.swift
//  FriendFace
//
//  Created by Marvin Lee Kobert on 06.04.22.
//
//

import Foundation
import CoreData


extension CachedFriend {
  @nonobjc public class func fetchRequest() -> NSFetchRequest<CachedFriend> {
    return NSFetchRequest<CachedFriend>(entityName: "CachedFriend")
  }

  @NSManaged public var id: String?
  @NSManaged public var name: String?

  @NSManaged public var users: NSSet?
}

// MARK: - Fronted Properties
extension CachedFriend {
  public var wrappedID: String {
    get { self.id ?? "No ID found." }
    set { self.id = newValue }
  }

  public var wrappedName: String {
    get { self.name ?? "Unknown Name" }
    set { self.name = newValue }
  }

  var usersArray: [CachedUser] {
    let usersSet = users as? Set<CachedUser> ?? []

    return usersSet.sorted { $0.wrappedName < $1.wrappedName }
  }
}

// MARK: Generated accessors for user
extension CachedFriend {
  @objc(addUsersObject:)
  @NSManaged public func addToUsers(_ value: CachedUser)

  @objc(removeUsersObject:)
  @NSManaged public func removeFromUsers(_ value: CachedUser)

  @objc(addUsers:)
  @NSManaged public func addToUsers(_ values: NSSet)

  @objc(removeUsers:)
  @NSManaged public func removeFromUsers(_ values: NSSet)
}

extension CachedFriend: Identifiable {}
