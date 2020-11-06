//
//  ViewController.swift
//  GetIPAddress
//
//  Created by mac on 06/11/20.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var lblGetIPAddress: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lblGetIPAddress.text = self.getIPAddress()
    }

    func getIPAddress() -> String {
            var address: String = ""
        var ifaddr: UnsafeMutablePointer<ifaddrs>? = nil
            if getifaddrs(&ifaddr) == 0 {
                var ptr = ifaddr
                while ptr != nil {
                    defer { ptr = ptr?.pointee.ifa_next }
                    
                    let interface = ptr?.pointee
                    let addrFamily = interface?.ifa_addr.pointee.sa_family
                    if addrFamily == UInt8(AF_INET) || addrFamily == UInt8(AF_INET6) {
                        
                          if let name: String = String(cString: (interface?.ifa_name)!), name == "en2" {
                            print(name)
                            var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                            getnameinfo(interface?.ifa_addr, socklen_t((interface?.ifa_addr.pointee.sa_len)!), &hostname, socklen_t(hostname.count), nil, socklen_t(0), NI_NUMERICHOST)
                            address = String(cString: hostname)
                            print(address)
                         }
                    }
                }
                freeifaddrs(ifaddr)
            }
             return address
        }

}

