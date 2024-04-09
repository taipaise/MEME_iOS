//
//  NetworkProvider.swift
//  MEME
//
//  Created by 이동현 on 2/2/24.
//

import Foundation
import Moya

final class NetworkProvider<API: MemeAPI> {
    
    private let provider: MoyaProvider<API>
    
    init(plugins: [PluginType] = [NetworkLoggerPlugin()]) {
        self.provider = MoyaProvider(plugins: plugins)
    }
    
    /// file, function, line은 디버깅 목적
    /// file: 현재 소스 파일의 경로
    /// function: 현재 호출된 함수의 이름
    /// line: 현재 호출된 라인의 번호
    func request(api: API, completion: @escaping (Result<Response, MoyaError>) -> Void) {
        let requestString = "\(api.urlPath)"
        
        provider.request(api) { result in
            switch result {
            case let .success(response):
                print("SUCCESS: \(requestString) (\(response.statusCode))")
                completion(.success(response))
                
            case let .failure(error):
                print("ERROR: \(requestString)")
                completion(.failure(error))
            }
        }
    }
    
    @discardableResult
    func requestCancellable(api: API, completion: @escaping Completion) -> Cancellable {
        let cancellable = provider.request(api, completion: completion)
        return cancellable
    }
    
    func request(api: API) async -> Result<Response, MoyaError> {
        let result = await provider.request(api)
        return result
    }
}
