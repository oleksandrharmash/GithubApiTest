//
//  ApiRouter.swift
//  GithubApiSample
//
//  Created by Oleksandr Harmash on 7/16/19.
//  Copyright © 2019 OG. All rights reserved.
//

import Alamofire

protocol ApiRouter {
    typealias RequestCompletion<T: BaseResponse> = (_ result: RequestResult<T>) -> ()

    var sessionManager: SessionManager { get }
    var baseURL: String { get }
    var apiRelativePath: String { get }
}

extension ApiRouter where Self: ApiRouter {
    func request(
        path: String,
        method: HTTPMethod = .get,
        parameters: Parameters? = nil,
        encoding: ParameterEncoding = URLEncoding.default,
        headers: HTTPHeaders? = nil) -> DataRequest {
        return sessionManager.request(path, method: method, parameters: parameters, encoding: encoding, headers: headers)
    }

    @discardableResult
    func request<T: BaseResponse>(
        path: String,
        method: HTTPMethod = .get,
        parameters: Parameters? = nil,
        encoding: ParameterEncoding = URLEncoding.default,
        headers: HTTPHeaders? = nil,
        completionHandler: RequestCompletion<T>? = nil) -> DataRequest {
        
        let fullPath = String(format: "%@/%@", apiRelativePath, path)
        let request = self.request(path: fullPath, method: method, parameters: parameters, encoding: encoding, headers: headers)
        
        guard let completion = completionHandler else { return request }
        
        request.validate().responseData(completionHandler: { response in
            self.process(response: response, completion: completion)
        })
        
        return request
    }
}

private extension ApiRouter {
    func process<T: BaseResponse>(response: DataResponse<Data>, completion: RequestCompletion<T>) {
        switch response.result {
        case .failure(let error):
            if let data = response.data,
                let reason = try? JSONDecoder().decode(FailReason.self, from: data) {
                completion(RequestResult<T>.fail(error: reason))
            } else {
                let reason: FailReason = FailReason(description: error.localizedDescription)
                completion(RequestResult<T>.fail(error: reason))
            }
        case .success(let value):
            do {
                let data: T? = try T(data: value)
                completion(RequestResult<T>.success(data: data))
            } catch {
                let reason: FailReason = FailReason(description: error.localizedDescription)
                completion(RequestResult<T>.fail(error: reason))
            }
        }
    }
}


