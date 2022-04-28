//
//  Stuff+CoreDataProperties.swift
//  Nano1
//
//  Created by Levina Niolana on 27/04/22.
//
//

import Foundation
import CoreData


extension Stuff {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Stuff> {
        return NSFetchRequest<Stuff>(entityName: "Stuff")
    }

    @NSManaged public var stuffLocation: String?
    @NSManaged public var stuffName: String?
    @NSManaged public var stuffNote: String?
    @NSManaged public var stuffStatus: String?
    @NSManaged public var has: Category?

}

extension Stuff : Identifiable {

}
