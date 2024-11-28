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
        VStack {
            Text("Sign Up")
                .font(.largeTitle)
                .padding()
            
            TextField("Username", text: $username)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            SecureField("Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            SecureField("Confirm Password", text: $confirmPassword)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            if !errorMessage.isEmpty {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            }
            
            Button("Sign Up") {
                if isValidSignUp() {
                    saveUserAccount() // Save the user data to Core Data
                } else {
                    errorMessage = "Passwords don't match or missing fields."
                }
            }
            .padding()
            .foregroundColor(.blue)
            
            // Navigate to Login page after sign-up
            if isSignedUp {
                NavigationLink("Go to Login", destination: LoginPageView(), isActive: $isSignedUp)
            }
        }
        .navigationTitle("Sign Up")
        .padding()
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
