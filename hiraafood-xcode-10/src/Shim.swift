import Foundation

enum ServerMode {
    case mock, local, remote
}

let mode:ServerMode = .mock
class Shim: NSObject {
    
    static private var singleton:ServerProtocol?
    
    func server() -> ServerProtocol {
        if Shim.singleton != nil {
            return Shim.singleton!
        }
        switch mode {
        case .mock:
            return MockServer()
        case .local:
            Shim.singleton =  RemoteServer("http://localhost:9000")
        case .remote:
            Shim.singleton = RemoteServer("https://hiraafood.com")
        }
        return Shim.singleton!
    }
}
