//
//  Category+CoreDataProperties.swift
//  Nano1
//
//  Created by Levina Niolana on 27/04/22.
//
//

import Foundation
import CoreData


extension Category {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Category> {
        return NSFetchRequest<Category>(entityName: "Category")
    }

    @NSManaged public var categoryName: String?
    @NSManaged public var partOf: NSSet?

}

// MARK: Generated accessors for partOf
extension Category {

    @objc(addPartOfObject:)
    @NSManaged public func addToPartOf(_ value: Stuff)

    @objc(removePartOfObject:)
    @NSManaged public func removeFromPartOf(_ value: Stuff)

    @objc(addPartOf:)
    @NSManaged public func addToPartOf(_ values: NSSet)

    @objc(removePartOf:)
    @NSManaged public func removeFromPartOf(_ values: NSSet)

}

extension Category : Identifiable {

}
