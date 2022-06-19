

import Foundation


enum NetworkResponse<T, U: Error> {
    
    case success(T)
    case failure(U)
    
}

