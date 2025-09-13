//
//  ContentView.swift
//  mobile_project_swift
//
//  Created by Денис Войтенко on 13.09.2025.
//

import SwiftUI

struct ContentView: View {
    @Binding var document: mobile_project_swiftDocument

    var body: some View {
        TextEditor(text: $document.text)
    }
}

#Preview {
    ContentView(document: .constant(mobile_project_swiftDocument()))
}
