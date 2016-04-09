import Foundation
import Contacts

public func labeledValuesDescription(values: [CNLabeledValue]) -> String
{
    let parts = values.map() {
        (item) -> String? in
        
        var itemDescription: String? = nil
        
        if let description = item.value as? String {
            let label = CNLabeledValue.localizedStringForLabel(item.label)
            itemDescription = "\(label) \(description)"
        }
        
        return itemDescription
    }
    
    var fullDescription: [String] = []
    
    parts.forEach() { (item: String?) in
        if let valid = item {
            fullDescription.append(valid)
        }
    }
    
    let toDisplay = fullDescription.joinWithSeparator(", ")
    
    return toDisplay
}


public func logContact(contact: CNContact, keysToFetch: [CNKeyDescriptor])
{
    let available = contact.areKeysAvailable(keysToFetch)
    
    if ( available ) {
        //: When keys are available, just log the contact informations
        let name     = contact.givenName
        let lastName = contact.familyName
        let emails   = labeledValuesDescription(contact.emailAddresses)
        let phones   = labeledValuesDescription(contact.phoneNumbers)
        
        if ( "" != emails || "" != phones ) {
            print("\(lastName) \(name):\n\temails = \(emails)\n\tphones = \(phones)")
        }
    }

}