import Foundation

protocol HasUniqueKeyProtocol {
    var uniqueKey:String {get}
}
// ----------------------------------------------------
/*
 * Tabular data protocol.
 * Associated types are Model and Element
 *
 */
protocol Tabular {
    associatedtype Element  //item
    
    init()
    var numberOfElements:Int {get}
    var isEmpty:Bool {get}
    subscript (key:String) -> Element? {get}
    func addElement(_ e:Element) throws -> Void
    var items:[Element] {get}
    
}


// ----------------------------------------------------

class BaseTabular<E:Codable & HasUniqueKeyProtocol> : Tabular {
    typealias Element = E
    private var _items : [E]
    
    enum Keys : String,CodingKey {
        case items
    }
    
    required init() {
        _items = [E]()
    }
    required init(from decoder:Decoder) throws {
        let container = try decoder.container(keyedBy: Keys.self)
        self._items = [E]()
        var arrayDecoder = try container.nestedUnkeyedContainer(forKey: .items)
        while !arrayDecoder.isAtEnd {
            let item:E = try arrayDecoder.decode(E.self)
            try self.addElement(item)
        }
    }
    
    func encode(to encoder:Encoder) throws {
        var container = encoder.container(keyedBy: Keys.self)
        try container.encode(_items, forKey: .items)
    }
    
    var numberOfElements: Int {return self._items.count}
    var isEmpty: Bool {return _items.count == 0}
    
    /*
     * element with given key
     */
    subscript(key: String) -> E? {
        for item in _items {
            if item.uniqueKey == key {
                return item
            }
        }
        return nil
    }
    
    subscript (index:Int) -> E? {
        get {
            return _items[index]
        }
    }
    
    func addElement(_ e: E) throws {
        //let key = e.uniqueKey
        /*
         if self[key] != nil {
         print("***ERROR:can not add \(type(of:e)) with key \(key). Becuase an element with same key exixts")
         print(_items)
         throw NSError(domain: "internal", code: 1000,
         userInfo:["error": "\(key) exists"])
         } else {
         _items.append(e)
         }
         */
        _items.append(e)
    }
    
    var items:[E] {
        return _items
    }
}

// ----------------------------------------------------
class ServerInfo:Codable {
    var name:String    = ""
    var version:String = ""
    var build:String   = ""
    var logo:String    = ""
    var paymentGateway:PaymentGateway?
    
    
}
// ----------------------------------------------------
class PaymentGateway:Codable {
    var key_id:String
    var key_secret:String
    
    init(key:String,secret:String) {
        self.key_id     = key
        self.key_secret = secret
    }
}
// ----------------------------------------------------
class OrderItem : Codable,HasUniqueKeyProtocol,CustomStringConvertible {
    var sku:String
    var name:String
    var units:Int
    var comment:String
    var price:Double
    
    var description:String {
        get {
            return "\(self.sku):(\(self.units))  \(self.price) "
        }
    }
    
    init(sku:String, name:String, units:Int, price:Double, comment:String?="") {
        self.sku = sku
        self.name = name
        self.units = units
        self.price = price
        self.comment = comment!
    }
    
    var uniqueKey:String {
        return sku
    }
}
// ----------------------------------------------------
class Payorder : Codable {
    var id:String
    var entity:String = "order"
    var amount:Double
    var amount_paid:Double
    var amount_due:Double
    var currency:String
    var receipt:String
    var offer_id:String?
    var status:String
    var attempts:Int
    var notes:[String]
    var created_at:Int
    
    init(invoice:Invoice) {
        id = invoice.id
        entity = "order"
        amount = invoice.amount
        amount_paid = 0
        amount_due = amount
        currency = "INR"
        receipt = invoice.id
        offer_id = ""
        status = ""
        attempts = 0
        notes = [String]()
        created_at = 0
    }
}
// ----------------------------------------------------
class User {
    var id:String = ""
    var name:String = ""
    var fullName:String = ""
    var phone:String = ""
    var email:String = ""
    
    init() {
        id   = "tester"
        name = "tester"
        fullName = "hiraafood tester"
        phone = "123456789"
        email = "tester@hiraafood.com"
    }
}
// ----------------------------------------------------

class Item : Codable,HasUniqueKeyProtocol {
    var uniqueKey:String {return sku}
    
    var sku:String   = ""
    var name:String  = ""
    var category:String = ""
    var price:Double = 0.0
    var description:String = ""
    var rating:Int = 1
    var image:String = ""
    
    init(sku:String, name:String,
         category:String,
         price:Double,
         desc:String?,
         rating:Int?,
         image:String?) {
        self.sku = sku
        self.name = name
        self.category = category
        self.price = price
        self.description = desc ?? ""
        self.rating = rating ?? 3
        self.image = image ?? ""
    }
    
}
// ----------------------------------------------------
/*
 * initailize evry field
 * make fields that may not in network response
 * optional
 */
class Address: Codable {
    var kind: String   = ""
    var owner: String? = ""
    var line1: String? = ""
    var line2: String? = ""
    var city: String?  = ""
    var zip: String?   = ""
    var tips: String?  = ""
    
    init(kind:String,
         owner:String? = "",
         line1:String,
         zip:String,
         line2:String? = "",
         city:String?  = "",
         tips:String?  = "") {
        
        self.kind  = kind
        self.owner = owner
        self.line1 = line1
        self.line2 = line2
        self.city = city
        self.zip  = zip
        self.tips = tips
    }
}

// ----------------------------------------------------

enum InvoiceItemKind : String, Codable, CaseIterable {
    case PRICE,TAX,DISCOUNT
}
class InvoiceItem : Codable,HasUniqueKeyProtocol,CustomStringConvertible {
    var kind:InvoiceItemKind = .PRICE
    var id: Int
    var invoice:String
    var sku:String
    var description:String
    var amount:Double = 0.0
    
    init(kind:InvoiceItemKind,id:Int,invoice:String,sku:String,description:String,amount:Double) {
        self.kind = kind
        self.id   =  id
        self.invoice = invoice
        self.sku = sku
        self.description = description
        self.amount = amount
    }
    
    var uniqueKey:String {
        return "\(id):\(kind.rawValue)"
    }
    
    
}


// ----------------------------------------------------
/*
 * This data structure is decoded from JSON server
 * response.
 * The fields are same as server response.
 *
 */
class Invoice: BaseTabular<InvoiceItem>, Codable {
    typealias Element = InvoiceItem
    var id:String = ""
    var amount:Double = 0.0
    var payorder:Payorder?
    var deliveryAddress:Address?
    var billingAddress:Address?
    
    enum CodingKeys:CodingKey {
        case id,amount,payorder,deliveryAddress,billingAddress
    }
    
    convenience init(id:String) {
        self.init()
        self.id = id
    }
    
    required init() {
        super.init()
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Invoice.CodingKeys.self)
        self.id     = try container.decode(String.self, forKey:.id)
        self.amount = try container.decode(Double.self, forKey:.amount)
        self.payorder = try container.decode(Payorder.self, forKey:.payorder)
        self.deliveryAddress = try container.decode(Address.self, forKey:.deliveryAddress)
        self.billingAddress = try container.decode(Address.self, forKey:.billingAddress)
        try super.init(from: decoder)
    }
    
}

class Cart: BaseTabular<OrderItem>, Codable {
    var total:Double = 0.0
    override func addElement(_ e:OrderItem) throws -> Void {
        let existing = self[e.sku]
        let price:Double = e.price
        total += price
        if existing == nil {
            print("adding new \(e) to \(self)")
            try super.addElement(e)
        } else {
            existing!.price   = e.price
            existing!.units   = e.units
            existing!.comment = e.comment
            print("updated existing \(existing!) in \(self)")
        }
    }
}


