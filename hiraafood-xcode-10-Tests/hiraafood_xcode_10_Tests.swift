import XCTest
@testable import hiraafood

class hiraafood_xcode_10_Tests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testServerInfo() throws {
        let serverResponse:String = """
{
    "name":"hiraafood",
    "version":"1.0.2",
    "build": "",
    "logo":"",
    "paymentGateway": {
        "key_id": "xxx",
        "key_secret": "yyy"
    }
}
        
"""
        let info = try JSONDecoder().decode(
            ServerInfo.self,
            from: serverResponse.data(using: .utf8)!)
        
        assert(info.name == "hiraafood")
        assert(info.paymentGateway?.key_id == "xxx")
        
    }

    func testOrder() throws {
        
        let serverResponse:String = """
{
    "id"      : "24",
    "total"   : 42,
    "created" : "",
    "status"  : "",
    "user"    :    "",
    "time_offset": "",
    "items": [
        {"sku":"", "name":"", "units":1, "price": 1.99,  "comment":""},
        {"sku":"", "name":"", "units":2, "price": 2.99,  "comment":""}
    ]
}
"""
 
        do {
        let order = try JSONDecoder().decode(
            Order.self,
            from: serverResponse.data(using: .utf8)!)
        print(order)
        assert(order.id == "24")
        assert(order.total == 42)
        assert(order.items.count == 2)
        } catch {
            print("==================================")
            print(error)
            print("==================================")
            throw error
        }
    }


    
    func testMenu() throws {
        let serverResponse = """
[
{
"category" : "veg",
"rating" : 3,
"sku" : "101",
"price" : 5,
"image" : "/images/item/veg-thali.jpg",
"description" : "Three vegetable served with served with rich 2 chapatis",
"name" : "vegeterian thali",
"tags" : null
},
{
"category" : "veg",
"rating" : 3,
"sku" : "102",
"price" : 8.70,
"image" : "/images/item/singara.jpg",
"description" : "Alooo gobi wrapped an samosa",
"name" : "vegetable samosa",
"tags" : null
},
{
"category" : "veg",
"rating" : 3,
"sku" : "103",
"price" : 6.20,
"image" : "/images/item/gobi-manchurian.jpg",
"description" : "cauliflower in indo-chience style",
"name" : "Gobi Manchurian",
"tags" : "spicy"
},
{
"category" : "non-veg",
"rating" : 3,
"sku" : "201",
"price" : 15.00,
"image" : "/images/item/non-veg-thali.jpg",
"description" : "Three vegetable served with served witth rich 2 chapatis",
"name" : "non-veg thali",
"tags" : null
},
{
"category" : "chicken",
"rating" : 3,
"sku" : "202",
"price" : 9.00,
"image" : "/images/item/chicken-manchurian.jpg",
"description" : "indian chinese style chicken",
"name" : "Chicken Manchurian",
"tags" : null
},
{
"category" : "fish",
"rating" : 3,
"sku" : "301",
"price" : 9.00,
"image" : "/images/item/prawn-with-rice.jpg",
"description" : "succulent prawns cooked in thick coconut gravy. Servred with long grain Basamati rice",
"name" : "Prawn with rice",
"tags" : null
}
]
"""
        _ = try JSONDecoder()
            .decode([Item].self,
            from:serverResponse.data(using:.utf8)!)
        
    }



func testItem() throws {
    let serverResponse:String = """
{
"category" : "fish",
"rating" : 3,
"sku" : "301",
"price" : 9.00,
"image" : "/images/item/prawn-with-rice.jpg",
"description" : "succulent prawns cooked in thick coconut gravy. Servred with long grain Basamati rice",
"name" : "Prawn with rice",
"tags" : null
}
"""
    let item = try JSONDecoder()
        .decode(Item.self,
                from:serverResponse.data(using:.utf8)!)
    
    assert(item.sku == "301")
    assert(item.rating == 3)
    assert(item.category == "fish")
    
}
    
    
    func testInvoice () throws {
        let serverResponse:String = """
        {
        "amount" : 9.6300000000000008,
        "id" : "42",
        "billingAddress" : {
            "owner" : "tester",
            "city" : "Deshbandhu Nagar",
            "id" : 5,
            "line2" : null,
            "zip" : "70059",
            "kind" : "billing",
            "line1" : "AA 10/7",
            "tips" : null
        },
        "items" : [
        {
        "amount" : 9,
        "id" : 0,
        "kind" : "PRICE",
        "invoice" : "42",
        "description" : "price for item",
        "sku" : "202"
        },
        {
        "amount" : 0.63,
        "id" : 1,
        "kind" : "TAX",
        "invoice" : "42",
        "description" : "sales tax @7%",
        "sku" : ""
        }
        ],
        "payorder" : {
            "id" : "order_FEwNhGZig1Et0R",
            "entity" : "order",
            "amount_paid" : 0,
            "amount" : 963,
            "created_at" : 1594853059,
            "amount_due" : 963,
            "offer_id" : "null",
            "attempts" : 0,
            "notes" : [
            
            ],
            "receipt" : "42",
            "currency" : "INR",
            "status" : "created"
        },
        "deliveryAddress" : {
            "owner" : "tester",
            "city" : "Deshbandhu Nagar",
            "id" : 4,
            "line2" : null,
            "zip" : "70059",
            "kind" : "home",
            "line1" : "AA 10/7",
            "tips" : null
        }
    }
"""
        let invoice = try JSONDecoder()
        .decode(Invoice.self, from: serverResponse.data(using: .utf8)!)
        assert(invoice.id == "42")
        

        assert(invoice.amount > 0)
        assert(invoice.payorder != nil)
        assert(invoice.payorder?.id == "order_FEwNhGZig1Et0R")
        assert(invoice.billingAddress != nil)
        assert(invoice.deliveryAddress != nil)
        
        }
    
    
    
    func testInvoiceItem() throws {
        let serverResponse:String = """
{
        "amount" : 9,
        "id" : 0,
        "kind" : "PRICE",
        "invoice" : "42",
        "description" : "price for item",
        "sku" : "202"
        }
"""
        
        let item = try JSONDecoder()
            .decode(InvoiceItem.self, from: serverResponse.data(using:.utf8)!)
        
        assert(item.invoice == "42")
    }
    
    func testPayorder() throws {
        let serverResponse:String = """
{
            "id" : "order_FEwNhGZig1Et0R",
            "entity" : "order",
            "amount_paid" : 0,
            "amount" : 963,
            "created_at" : 1594853059,
            "amount_due" : 963,
            "offer_id" : "null",
            "attempts" : 0,
            "notes" : [
            
            ],
            "receipt" : "42",
            "currency" : "INR",
            "status" : "created"
        }
"""
        
        let payorder = try JSONDecoder()
            .decode(Payorder.self, from: serverResponse.data(using:.utf8)!)
        
        assert(payorder.id == "order_FEwNhGZig1Et0R")

    }
    
    func testAddress() throws {
        let serverResponse:String = """
{
            "owner" : "tester",
            "city" : "Deshbandhu Nagar",
            "id" : 4,
            "line2" : null,
            "zip" : "70059",
            "kind" : "home",
            "line1" : "AA 10/7",
            "tips" : null
        }
"""
        
        let address = try JSONDecoder()
            .decode(Address.self, from: serverResponse.data(using:.utf8)!)
        
        assert(address.line1 == "AA 10/7")
    }
}



