import Passwordless
import SwiftUI

struct DemoRegistrationView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var environment: DemoEnvironmentItems
    @State private var alertItem: AlertItem?
    @State private var username: String = ""
    @State private var firstName: String = ""
    @State private var lastName: String = ""

    var body: some View {
        VStack {
            TextField("Username", text: $username)
                .textFieldStyle(.roundedBorder)
            TextField("First Name", text: $firstName)
                .textFieldStyle(.roundedBorder)
            TextField("Last Name", text: $lastName)
                .textFieldStyle(.roundedBorder)
            requestButton
            Spacer()
        }
        .padding()
        .navigationStyle("Registration")
        .alert(item: $alertItem) { item in
            Alert(
                title: Text(item.title),
                message: Text(item.message),
                dismissButton: .cancel(Text("OK"))
            )
        }
    }

    private var requestButton: some View {
        Button {
            requestAuthorization()
        } label: {
            HStack {
                Image(systemName: "person.badge.key.fill")
                Text("Register Passkey And Sign in")
            }
        }
        .disabled(username.isEmpty)
        .tint(.red)
        .buttonStyle(.borderedProminent)
    }

    private func requestAuthorization() {
        Task {
            environment.showLoader = true
            defer { environment.showLoader = false }
            do {
                let registrationToken = await environment.services.demoAPIService.register(
                    username: username,
                    firstName: firstName,
                    lastName: lastName
                ).token
                let verifyToken = try await environment.services.passwordlessClient.register(token: registrationToken)
                let jwtToken = await environment.services.demoAPIService.login(verifyToken: verifyToken)
                environment.authToken = jwtToken.jwtToken
                environment.userId = try jwtToken.jwtToken.decodedUserName()

                await MainActor.run {
                    dismiss()
                }
            } catch PasswordlessClientError.authorizationCancelled {
                print("Cancelled")
            } catch {
                print(error)

                alertItem = AlertItem(
                    title: "Registration issue",
                    message: "\(error)"
                )
            }
        }
    }
}

#Preview {
    DemoRegistrationView()
}
