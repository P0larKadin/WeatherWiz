//
//  LoginView.swift
//  WeatherWiz
//
//  Created by Kadin Oake on 2026-02-27.
//

import SwiftUI
import SwiftData

struct LoginView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) var dismiss

    // SELECT * FROM UserPreferences
    @Query private var allUsers: [UserPreferences]

    @State private var usernameInput: String = ""
    @State private var passwordInput: String = ""
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""

    // Tells ContentView who logged in
    @Binding var loggedInUser: UserPreferences?

    var body: some View {
        VStack(spacing: 20) {

            Text("WeatherWiz")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.bottom, 10)

            Text("Sign In")
                .font(.headline)
                .foregroundColor(.gray)
                .padding(.bottom, 20)

            TextField("Username", text: $usernameInput)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .autocapitalization(.none)
                .disableAutocorrection(true)
                .padding(.horizontal)

            SecureField("Password", text: $passwordInput)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)

            Button(action: {
                handleLogin()
            }) {
                Text("Log In")
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
                    .padding(.horizontal)
            }
            .padding(.top, 10)
        }
        .padding()
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Login Failed"),
                message: Text(alertMessage),
                dismissButton: .default(Text("OK"))
            )
        }
    }

    private func handleLogin() {
        guard !usernameInput.isEmpty, !passwordInput.isEmpty else {
            alertMessage = "Please enter both username and password."
            showAlert = true
            return
        }

        // SELECT * FROM UserPreferences WHERE username = usernameInput
        // NOTE: Add && user.password == passwordInput once password is added to UserPreferences
        if let matchedUser = allUsers.first(where: { $0.username == usernameInput }) {
            loggedInUser = matchedUser
            dismiss()
        } else {
            alertMessage = "Invalid username or password."
            showAlert = true
        }
    }
}
