//
//  AuthManager.swift
//  DemoFireBase
//
//  Created by namtrinh on 30/12/2020.
//

import FirebaseAuth
import FirebaseFirestore

public class AuthManager {
    
    static let shared = AuthManager()
    
    private init() { }
    
    public func registerNewUser(username: String, email: String, password: String, completion: @escaping(Bool) -> Void ) {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if error != nil {
                completion(false)
                return
            }
            let db = Firestore.firestore()
            db.collection("users").addDocument(data: ["email" : email, "username": username, "uid": result!.user.uid]) { (error) in
                if error != nil {
                    print("Error saving user \(String(describing: error))")
                }
            }
            completion(true)
        }
    }
    
    public func loginUser(email: String, password: String, completion: @escaping (Bool) -> Void ) {
            Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                if error != nil {
                    completion(false)
                    return
                }
                completion(true)
            }
    }
    
    public func logOut(completion: (Bool) -> Void) {
        do {
            try Auth.auth().signOut()
            completion(true)
            return
        }
        catch {
            completion(false)
            print(error)
        }
    }
    
}
