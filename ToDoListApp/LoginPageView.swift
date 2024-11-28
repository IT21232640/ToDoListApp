import SwiftUI
import CoreData

struct LoginPageView: View {
    @Environment(\.managedObjectContext) private var viewContext // Core Data context
    
    @State private var username = ""
    @State private var password = ""
    @State private var isLoggedIn = false
    @State private var errorMessage = ""
    
    var body: some View {
        VStack {
            Text("Login")
                .font(.largeTitle)
                .padding()

            TextField("Username", text: $username)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            SecureField("Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            if !errorMessage.isEmpty {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            }

            Button("Login") {
                if isValidLogin() {
                    isLoggedIn = true
                } else {
                    errorMessage = "Invalid username or password."
                }
            }
            .padding()
            .foregroundColor(.blue)

            NavigationLink(destination: SignUpPageView()) {
                Text("Don't have an account? Sign Up")
            }
            .padding()

            // Navigate to TaskPageView when logged in
            if isLoggedIn {
                NavigationLink("", destination: TaskPageView(), isActive: $isLoggedIn)
            }
        }
        .navigationTitle("Login")
        .padding()
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
