import SwiftUI

struct HomePageView: View {
    var body: some View {
        NavigationView {
            VStack {
                Text("Hi, Welcome to the To-Do List App!")
                    .font(.largeTitle)
                    .padding()
                

                NavigationLink(destination: LoginPageView()) {
                    Text("Start")
                        .foregroundColor(.blue)
                        .font(.title2)
                }
                .padding()
            }
            .navigationTitle("Home")
        }
    }
}
