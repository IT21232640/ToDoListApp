import SwiftUI
import CoreData

struct SignUpPageView: View {
    @Environment(\.managedObjectContext) private var viewContext // Access to Core Data context
    
    @State private var username = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var isSignedUp = false
    @State private var errorMessage = ""
    
    var body: some View {
        ZStack {
            // Background Gradient
            LinearGradient(
                gradient: Gradient(colors: [Color.blue.opacity(0.6), Color.purple]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 30) {
                // Title
                Text("Create Your Account")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.top, 50)
                
                Text("Sign up to start using the app")
                    .foregroundColor(.white.opacity(0.8))
                    .font(.headline)
                
                // Username Field
                TextField("Username", text: $username)
                    .padding()
                    .background(Color.white.opacity(0.8))
                    .cornerRadius(10)
                    .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
                    .padding(.horizontal)
                
                // Password Field
                SecureField("Password", text: $password)
                    .padding()
                    .background(Color.white.opacity(0.8))
                    .cornerRadius(10)
                    .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
                    .padding(.horizontal)
                
                // Confirm Password Field
                SecureField("Confirm Password", text: $confirmPassword)
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
                
                // Sign Up Button
                Button(action: {
                    if isValidSignUp() {
                        saveUserAccount()
                    } else {
                        errorMessage = "Passwords don't match or missing fields."
                    }
                }) {
                    Text("Sign Up")
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.purple)
                        .cornerRadius(10)
                        .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 5)
                }
                .padding(.horizontal)
                
                // Login Link
                NavigationLink(destination: LoginPageView()) {
                    Text("Already have an account? Log In")
                        .foregroundColor(.white)
                        .underline()
                }
                
                Spacer()
            }
            .padding()
        }
        .navigationBarBackButtonHidden(true) // Hides the back button
        .navigationBarTitle("", displayMode: .inline) // Removes navigation title
    }
    
    // Validate signup logic
    private func isValidSignUp() -> Bool {
        return !username.isEmpty && !password.isEmpty && password == confirmPassword
    }
    
    // Save user account to Core Data
    private func saveUserAccount() {
        let newUser = User(context: viewContext)
        newUser.username = username
        newUser.password = password
        
        do {
            try viewContext.save()
            DispatchQueue.main.async {
                isSignedUp = true
            }
        } catch {
            print("Error saving account: \(error)") // Debugging log
            errorMessage = "There was an error saving your account: \(error.localizedDescription)"
        }
    }
}
