import SwiftUI

struct HomePageView: View {
    var body: some View {
        NavigationView {
            ZStack {
                // Background Gradient
                LinearGradient(
                    gradient: Gradient(colors: [Color.blue, Color.purple]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea() // Extend the gradient to the entire screen
                
                VStack(spacing: 40) {
                    // Welcome Text
                    Text("Welcome to the To-Do List App!")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 20)
                    
                    // Navigation Button
                    NavigationLink(destination: LoginPageView()) {
                        Text("Get Started")
                            .fontWeight(.bold)
                            .font(.title2)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.white)
                            .foregroundColor(Color.purple)
                            .cornerRadius(15)
                            .shadow(color: Color.black.opacity(0.3), radius: 10, x: 0, y: 5)
                    }
                    .padding(.horizontal, 40)
                    
                    // Footer
                    Spacer()
                }
                .padding(.top, 100)
            }
            .navigationTitle("")
            .navigationBarHidden(true) // Hide the default navigation bar
        }
    }
}
