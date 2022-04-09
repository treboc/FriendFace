//
//  CachedUser+CoreDataProperties.swift
//  FriendFace
//
//  Created by Marvin Lee Kobert on 06.04.22.
//
//

import Foundation
import CoreData
import UIKit


extension CachedUser {
  @nonobjc public class func fetchRequest() -> NSFetchRequest<CachedUser> {
    return NSFetchRequest<CachedUser>(entityName: "CachedUser")
  }

  @NSManaged public var id: String?
  @NSManaged public var isActive: Bool
  @NSManaged public var name: String?
  @NSManaged public var age: Int16
  @NSManaged public var company: String?
  @NSManaged public var about: String?
  @NSManaged public var address: String?
  @NSManaged public var registered: Date?

  @NSManaged public var friends: NSSet?
}

// Mark: - Fronted Properties
extension CachedUser {
  public var wrappedID: String {
    get { self.id ?? "Unknown ID" }
    set { self.id = newValue }
  }

  public var wrappedName: String {
    get { self.name ?? "Unknown Name" }
    set { self.name = newValue }
  }

  public var wrappedAge: Int {
    get { Int(self.age) }
    set { self.age = Int16(newValue) }
  }

  public var wrappedCompany: String {
    get { self.company ?? "Unknown Company" }
    set { self.company = newValue }
  }

  public var wrappedAbout: String {
    get { self.about ?? "Unknown About" }
    set { self.about = newValue }
  }

  public var wrappedAddress: String {
    get { self.address ?? "Unknown Address" }
    set { self.address = newValue }
  }

  public var wrappedRegistered: Date {
    get { self.registered ?? Date() }
    set { self.registered = newValue }
  }

  var friendsArray: [CachedFriend] {
    let friendsSet = friends as? Set<CachedFriend> ?? []

    return friendsSet.sorted { $0.wrappedName < $1.wrappedName }
  }
}

extension CachedUser {
  var joined: String {
    let components = Calendar.current.dateComponents([.year, .month], from: wrappedRegistered)
    if let year = components.year, let month = components.month {
      let writtenMonth = Calendar.current.monthSymbols[month - 1]
      return "joined \(writtenMonth), \(year)"
    }
    return ""
  }

  var addressAsCityAndState: String {
    let adressCompontens = wrappedAddress.components(separatedBy: ", ")
    let city = adressCompontens[1]
    let state = adressCompontens[2]
    return "\(city), \(state)"
  }
}


// MARK: Generated accessors for friend
extension CachedUser {
  @objc(addFriendsObject:)
  @NSManaged public func addToFriends(_ value: CachedFriend)

  @objc(removeFriendsObject:)
  @NSManaged public func removeFromFriends(_ value: CachedFriend)

  @objc(addFriends:)
  @NSManaged public func addToFriends(_ values: NSSet)

  @objc(removeFriends:)
  @NSManaged public func removeFromFriends(_ values: NSSet)
}

extension CachedUser: Identifiable {}
