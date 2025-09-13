//
//  mobile_project_swiftApp.swift
//  mobile_project_swift
//
//  Created by Денис Войтенко on 13.09.2025.
//

import SwiftUI

@main
struct mobile_project_swiftApp: App {
    var body: some Scene {
        DocumentGroup(newDocument: mobile_project_swiftDocument()) { file in
            ContentView(document: file.$document)
        }
    }
}
