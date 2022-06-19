//
//  NetworkMonitor.swift
//  MovieApp
//
//  Created by MacBook on 19.02.2022.
//

import Foundation
import Network

class NetworkMonitor {
    static let shared = NetworkMonitor()
    var monitor = NWPathMonitor()
    let queue = DispatchQueue.global()
    var isConnected: Bool = false
    var connectionType: ConnectionType = .unknown
    
    enum ConnectionType {
        case wifi
        case cellular
        case ethernet
        case unknown
    }
    private init() {
        monitor = NWPathMonitor()
    }
    func startMonitoring() {
        monitor.start(queue: queue)
        monitor.pathUpdateHandler = { [weak self] path in
            self?.isConnected = path.status == .satisfied
            self?.getConnectionType(path)

            print(path.isExpensive)
        }

        let queue = DispatchQueue(label: "NetworkMonitor")
        monitor.start(queue: queue)
    }

    func stopMonitoring() {
        monitor.cancel()
    }
    
    private func getConnectionType(_ path: NWPath) {
        if path.usesInterfaceType(.wifi) {
            connectionType = .wifi
        } else if path.usesInterfaceType(.cellular) {
            connectionType = .cellular
        } else if path.usesInterfaceType(.wiredEthernet) {
            connectionType = .ethernet
        } else {
            connectionType = .unknown
        }
    }
}
