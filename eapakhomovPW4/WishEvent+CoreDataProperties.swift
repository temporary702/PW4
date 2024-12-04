//
//  WishEvent+CoreDataProperties.swift
//  eapakhomovPW4
//
//  Created by flexorcist on 12/5/24.
//
//

import Foundation
import CoreData


extension WishEvent {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<WishEvent> {
        return NSFetchRequest<WishEvent>(entityName: "WishEvent")
    }

    @NSManaged public var title: String?
    @NSManaged public var eventDescription: String?
    @NSManaged public var startDate: Date?
    @NSManaged public var endDate: Date?

}

extension WishEvent : Identifiable {

}
