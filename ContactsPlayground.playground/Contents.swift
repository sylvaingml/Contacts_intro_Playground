/*: 
 # Introduction to Contacts API
 
 This playground introduce how to use the **Contact** framework
 introduced on iOS 9 and OS X 10.11.
 
 In this short introduction we will see how we can get contact objects
 from user's address book.
 
 **Note:**
 This playground is configured to be run in OS X environment, 
 but API is shared with iOS.
 
 
 ## References
 
 You can get full introduction to the **Contacts** framework in the
 [WWDC 2015 session 223](https://developer.apple.com/videos/play/wwdc2015/223/).
 
 Framework is documented 
 [here](https://developer.apple.com/library/watchos/documentation/Contacts/Reference/Contacts_Framework/).

 
 ## Contact Store
 
 Before we start we have to import the *Contact* framework.
 
*/
import Contacts

/*:
 
 Contacts are accessed via a store object.
 
 To get access to the store, you proceed in two steps:
 
 1. create a store
 2. get the default container identifier
 
 You can now use the store to fetch contacts.
 
 */
let store        = CNContactStore()

//: Each store has a default container identifier that is accessed as a property.
let storeDefault = store.defaultContainerIdentifier()

/*:
 
 ## Fetching contacts
 
 ### Fetch with predicate
 
 You can use predicate to fetch a subset of contacts.
 
 Predicate can be used to search a contact by part of name or identifier.
 
 */
//: In this first example I search by a part of name
let predicateByName: NSPredicate = CNContact.predicateForContactsMatchingName("a")

/*: 
 In this second predicate I search by giving a list of contact identifiers.

 You may use this *only* if you have store some identifiers in a previous flow.
 
 It is important to note that identifiers are *device-specific* (by the word of specs)
 so I guess it is not safe to rely on them if you need sync accros devices.
 
 */
let predicateById: NSPredicate = CNContact.predicateForContactsWithIdentifiers([])

/*: 
 I my small example I will only search by name.
 
 Change the following line to pick the good predicate.
 */
let predicate = predicateByName

/*: 
 I want to be able to fetch all contacts with a phone or an email adresse.
 I also need given name (*first name*) and family names (*last name*)
 
 For this you have to list properties you are interested in.
 */
let keysToFetch = [
    CNContactGivenNameKey,
    CNContactFamilyNameKey,
    
    CNContactEmailAddressesKey,
    CNContactPhoneNumbersKey
]

/*:
 
 Final step is to perform the fetch of contacts using both predicate and list of properties.
 
 */
let contacts = try store.unifiedContactsMatchingPredicate(
    predicate, keysToFetch: keysToFetch
)

/*:
 
 ### Fetching all contacts
 
 Another option, is to fetch all contacts.
 
 1. You must build a fetch request that specify which keys you need.
 2. Then you run the fetch request and applying a block of code on each returned contact.
 
 This way of going through contacts is really different than predicate.
 You do not get a full list of contact, but only one contact at a time.
 
 */
let fetchAllRequest = CNContactFetchRequest(keysToFetch: keysToFetch)

//: Create an empty list to store the result.
var allContacts = [CNContact]()

//: And now we can perform the fetch on the store using our request.
try store.enumerateContactsWithFetchRequest(fetchAllRequest) { (contact, isLast) in
    logContact(contact, keysToFetch: keysToFetch)
    allContacts.append(contact)
}

print("GOT ALL DONE: found \(allContacts.count) contacts in the store.")

/*: 
 
 ## Accessing contact properties
 
 In the attached source file you will find two utily functions:
 
 1. `logContact()` can dump a contact to the console
 2. `labeledValuesDescription()` is used to convert a list of `CNLabeledValue` to printable
    text.
 
 **Note:**
 Iterating through all returned contact I must take care to check if the keys I need are
 available. This is done in my external function.
 
 */
contacts.forEach() { (contact: CNContact) in
    logContact(contact, keysToFetch: keysToFetch)
}

/*:

 That's all for this first step.
 
 You just need to remember that for security reasons you might need to the user the right to
 access the address book. Check privacy API in `CNStore` class.
 
 - `authorizationStatusForEntityType(_:)`
 - `requestAccessForEntityType(_:completionHandler:)`

 
 -----
 
 [Sylvain Gamel](http://SylvainGamel.fr), April 2016
 
 */
