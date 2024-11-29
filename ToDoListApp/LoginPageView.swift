import SwiftUI
import CoreData

struct LoginPageView: View {
    @Environment(\.managedObjectContext) private var viewContext // Core Data context
    
    @State private var username = ""
    @State private var password = ""
    @State private var isLoggedIn = false
    @State private var errorMessage = ""
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background Gradient
                LinearGradient(
                    gradient: Gradient(colors: [Color.blue.opacity(0.6), Color.purple]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                VStack(spacing: 30) {
                    // Login Title
                    Text("Welcome Back!")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.top, 50)
                    
                    Text("Please login to continue")
                        .foregroundColor(.white.opacity(0.8))
                        .font(.headline)
                    
                    // Username Text Field
                    TextField("Username", text: $username)
                        .padding()
                        .background(Color.white.opacity(0.8))
                        .cornerRadius(10)
                        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
                        .padding(.horizontal)
                    
                    // Password Text Field
                    SecureField("Password", text: $password)
                        .padding()
                        .background(Color.white.opacity(0.8))
                        .cornerRadius(10)
                        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
                        .padding(.horizontal)
                    
                    // Error Message
                    if !errorMessage.isEmpty {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .font(.footnote)
                            .padding(.horizontal)
                    }
                    
                    // Login Button
                    Button(action: {
                        if isValidLogin() {
                            isLoggedIn = true
                        } else {
                            errorMessage = "Invalid username or password."
                        }
                    }) {
                        Text("Login")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.purple)
                            .cornerRadius(10)
                            .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 5)
                    }
                    .padding(.horizontal)
                    
                    // Sign Up Link
                    NavigationLink(destination: SignUpPageView()) {
                        Text("Don't have an account? Sign Up")
                            .foregroundColor(.white)
                            .underline()
                    }
                    
                    Spacer()
                }
                .padding()
                
                // Navigate to TaskPageView when logged in
                if isLoggedIn {
                    NavigationLink("", destination: TaskPageView(), isActive: $isLoggedIn)
                }
            }
            .navigationBarHidden(true) // Hide default navigation bar
        }
    }
    
    // Validate login using Core Data
    private func isValidLogin() -> Bool {
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "username == %@ AND password == %@", username, password)
        
        do {
            let users = try viewContext.fetch(fetchRequest)
            return !users.isEmpty
        } catch {
            print("Error fetching user: \(error)")
            errorMessage = "An error occurred during login."
            return false
        }
    }
}
