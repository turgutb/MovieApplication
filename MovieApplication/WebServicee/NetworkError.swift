
import Foundation

enum NetworkError: Error {
    case network
    case decoding

    var errorMessage: String {
        switch self {
        case .network:
            return "Fetching Error Occured."
        case .decoding:
            return "Decoding Error Occured."
        }
    }
}
