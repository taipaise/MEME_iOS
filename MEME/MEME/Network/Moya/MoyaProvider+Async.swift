//
//  MoyaProvider+Async.swift
//  MEME
//
//  Created by 이동현 on 4/5/24.
//

import Moya

extension MoyaProvider {
    func request(_ target: Target) async -> Result<Response, MoyaError> {
        let request = MoyaAsyncRequest { [weak self] continuation in
            guard let self else {
                let error = MoyaError.underlying(MoyaAsyncError.dealloc, nil)
                continuation.resume(returning: .failure(error))
                return nil
            }
            
            return self.request(target) { result in
                continuation.resume(returning: result)
            }
        }
        
        return await withTaskCancellationHandler {
            await withCheckedContinuation { continuation in
                request.perform(continuation: continuation)
            }
        } onCancel: {
            request.cancel()
        }
    }
}
