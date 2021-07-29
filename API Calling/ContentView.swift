//
//  ContentView.swift
//  API Calling
//
//  Created by Aneesh Pushparaj on 7/29/21.
//

import SwiftUI
struct ContentView: View {
    @State private var elements = [Element]()
    @State private var showingAlert = false
    var body: some View {
        Group {
            NavigationView {
                List(elements) { element in
                    NavigationLink(
                        destination: VStack {
                            Text(element.name)
                                .padding()
                            Text(element.symbol)
                                .padding()
                            Text(element.atomicNumber)
                                .padding()
                            Text(element.history)
                                .padding()
                            Text(element.facts)
                                .padding()
                        },
                        label: {
                            HStack {
                                Text(element.symbol)
                                Text(element.atomicNumber)
                                Text(element.name)
                            }
                        })
                        .navigationBarTitle("Periodic Table of Elements", displayMode: .inline)
                }
                .onAppear(perform: {
                    queryAPI()
                })
                .alert(isPresented: $showingAlert, content: {
                    Alert(title: Text("Loading Error"),
                          message: Text("There was a problem loading the data"),
                          dismissButton: .default(Text("OK")))
                })
                .preferredColorScheme(.dark)
            }
        }
    }
    
    func queryAPI() {
        let apiKey = "?rapidapi-key=4889f9e3f9msh837983776489b8cp12d1ddjsn0fb79206ee5b"
        let query = "https://periodictable.p.rapidapi.com/\(apiKey)"
        if let url = URL(string: query) {
            if let data = try? Data(contentsOf: url) {
                let json = try! JSON(data: data)
                let contents = json.arrayValue
                for item in contents {
                    let name = item["name"].stringValue
                    let symbol = item["symbol"].stringValue
                    let facts = item["facts"].stringValue
                    let history = item["history"].stringValue
                    let atomicNumber = item["atomicNumber"].stringValue
                    let element = Element(symbol: symbol, name: name, atomicNumber: atomicNumber, history:history, facts: facts)
                    elements.append(element)
                }
                return
            }
        }
        
        showingAlert = true
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct Element: Identifiable, Decodable {
    var id = UUID()
    let symbol: String
    let name: String
    let atomicNumber: String
    let history: String
    let facts: String
}
