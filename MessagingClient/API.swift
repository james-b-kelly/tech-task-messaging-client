//
//  API.swift
//  MessagingClient
//
//  Created by Jamie Kelly on 10/11/2024.
//

class API {
    
    enum APIError: Error {
        case network
        //... auth, invalidResponse, etc.
    }
    
    // Dummy function load chat JSON asynchronously as if from and API endpoint.
    func fetchChatJSON() async -> Result<[JSON], APIError> {
        //Simulate network delay.
        
        try? await Task.sleep(nanoseconds: 1 * 1_000_000_000)
        guard let json = JSONFileHelper.json(fromFileInBundleWithName: "code_test_data") else {
            return .failure(.network)
        }
        return .success(json)
    }
    
}
