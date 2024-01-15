//
//  DaemonDisabler.swift
//  Geranium
//
//  Created by cclerc on 15.12.23.
//

import Foundation

func daemonManagement(key: String, value: Bool, plistPath: String) {
    var result = ""
    result = RootHelper.removeItem(at: URL(fileURLWithPath: "/var/mobile/Documents/disabled.plist"))
    // copy plist
    var error = RootHelper.copy(from: URL(fileURLWithPath: plistPath), to: URL(fileURLWithPath: "/var/mobile/Documents/disabled.plist"))
    print(error)
    error = RootHelper.setPermission(url: URL(fileURLWithPath: "/var/mobile/Documents/disabled.plist"))
    guard let plistData = FileManager.default.contents(atPath: "/var/mobile/Documents/disabled.plist"),
          var plistDictionary = try? PropertyListSerialization.propertyList(from: plistData, options: [], format: nil) as? NSMutableDictionary
    else {
        print("Error")
        return
    }
    plistDictionary[key] = value
    print("new data being transmitted")
    if let newData = try? PropertyListSerialization.data(fromPropertyList: plistDictionary, format: .xml, options: 0) {
        do {
            try newData.write(to: URL(fileURLWithPath: "/var/mobile/Documents/disabled.plist"))
        } catch {
            print("Error \(error)")
        }
    } else {
        print("Error data convert")
    }
    // we need to do shit with roothelper
    print("roothelper")
    result = RootHelper.removeItem(at: URL(fileURLWithPath: plistPath))
    print(result)
    print("roothelper2")
    result = RootHelper.move(from: URL(fileURLWithPath :"/var/mobile/Documents/disabled.plist"), to: URL(fileURLWithPath: plistPath))
    if result != "0" {
        sendLog("error while deleting daemon. roothelper returned \(result)")
    }
    result = RootHelper.removeItem(at: URL(fileURLWithPath: "/var/mobile/Documents/disabled.plist"))
    print(result)
}
