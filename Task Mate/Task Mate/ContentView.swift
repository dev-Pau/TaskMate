//
//  ContentView.swift
//  Task Mate
//
//  Created by Pau Fernández Solà on 9/5/23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
       HomeView()
    }
}

#if DEBUG
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
