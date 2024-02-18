//
//  ContactManager.swift
//  MEME
//
//  Created by 임아영 on 2/18/24.
//

import Foundation
import Moya

final class ContactManager {
    typealias API = ContactAPI
    
    static let shared = ContactManager()
    let provider = NetworkProvider<API>(plugins: [NetworkLoggerPlugin()])
    
    func postContact(userId: Int, inquiryTitle: String, inquiryText: String, completion: @escaping (Result<ContactResponse, MoyaError>) -> Void) {
        provider.request(api: .postContact(userId: userId, inquiryTitle: inquiryTitle, inquiryText: inquiryText)) { result in
            switch result {
            case .success(let response):
                do {
                    let data = try JSONDecoder().decode(ContactResponse.self, from: response.data)
                    completion(.success(data))
                } catch {
                    completion(.failure(MoyaError.jsonMapping(response)))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
