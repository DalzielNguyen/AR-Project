//
//  NetworkService.swift
//  ProjectTrainning
//
//  Created by Le-Sang Nguyen on 7/29/20.
//  Copyright © 2020 Le-Sang Nguyen. All rights reserved.
//

import Foundation

class NetworkService {
    private var url: String
    private var method: HttpMethod = .get
    private var headers = [String: String]()
    private var body: Body?
    
    init(_ url: String) {
        self.url = url
    }
    
    func setMethod(_ method: HttpMethod) -> Self {
        self.method = method
        return self
    }
    
    func setBody(_ body: Body) -> Self {
        self.body = body
        return self
    }
    
    func setParams(_ dictionary: [String: Any?]) -> Self {
        url += encoding(dictionary)
        return self
    }
    
    func jsonBody(_ dictionary: [String: Any]) -> Self {
        let convertBody = JsonBody(dictionary)
        body = convertBody
        return self
    }
    
    func urlBody(_ dictionary: [String: Any]) -> Self {
        let convertBody = UrlEncodedBody(dictionary)
        body = convertBody
        return self
    }
    
    func setHeader(_ key: String, _ value: String) -> Self {
        headers[key] = value
        return self
    }
    
    func get<T>(_ parser: @escaping JsonParser<T>, completion: @escaping (Result<[T]>) -> Void) {
        guard let urlRequest = URL(string: url) else {
            DispatchQueue.main.async {
                completion(Result.failure(JsonReaderError.url))
            }
            return
        }
        var request = URLRequest(url: urlRequest)
        for header in headers {
            request.setValue(header.value, forHTTPHeaderField: header.key)
        }
        if method == .post {
            request.httpMethod = "POST"
            if body != nil {
                request.setValue(body?.contentType, forHTTPHeaderField: "Content-Type")
                request.httpBody = body?.data
            }
        } else if method == .get {
            request.httpMethod = "GET"
            if body != nil {
                DispatchQueue.main.async {
                    completion(Result.failure(BodyError.get))
                }
                return
            }
        }
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            do {
                if let err = error {
                    DispatchQueue.main.async {
                        completion(Result.failure(err))
                    }
                    return
                }
                guard let httpResponse = response as? HTTPURLResponse else {
                    DispatchQueue.main.async {
                        completion(Result.failure(JsonReaderError.response))
                    }
                    return
                }
                if httpResponse.statusCode != 200 {
                    DispatchQueue.main.async {
                        completion(Result.failure(HttpStatusError(data!, httpResponse.statusCode)))
                    }
                    return
                }
                var listValues = [T]()
                let convertData = try JsonReader(json: data!)
                print(convertData)
                let values = parser(convertData)
                print (values)
                listValues.append(values)
                
                DispatchQueue.main.async {
                    completion(Result.success(listValues))
                }
            } catch JsonReaderError.inputData {
                DispatchQueue.main.async {
                    completion(Result.failure(JsonReaderError.inputData))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(Result.failure(error))
                }
            }
        }
        task.resume()
    }
    
    func getList<T>(_ parser: @escaping JsonParser<T>, completion: @escaping (Result<[T]>) -> Void) {
        guard let urlRequest = URL(string: url) else {
            DispatchQueue.main.async {
                completion(Result.failure(JsonReaderError.url))
            }
            return
        }
        var request = URLRequest(url: urlRequest)
        for header in headers {
            request.setValue(header.value, forHTTPHeaderField: header.key)
        }
        if method == .post {
            request.httpMethod = "POST"
            if body != nil {
                request.setValue(body?.contentType, forHTTPHeaderField: "Content-Type")
                request.httpBody = body?.data
            }
        } else if method == .get {
            request.httpMethod = "GET"
            if body != nil {
                DispatchQueue.main.async {
                    completion(Result.failure(BodyError.get))
                }
                return
            }
        }
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            var listValues = [T]()
            do {
                if let err = error {
                    DispatchQueue.main.async {
                        completion(Result.failure(err))
                    }
                    return
                }
                guard let httpResponse = response as? HTTPURLResponse else {
                    DispatchQueue.main.async {
                        completion(Result.failure(JsonReaderError.response))
                    }
                    return
                }
                if httpResponse.statusCode != 200 {
                    DispatchQueue.main.async {
                        completion(Result.failure(HttpStatusError(data!, httpResponse.statusCode)))
                    }
                    return
                }
                
                if let listDatas = try JSONSerialization.jsonObject(with: data!, options: []) as? [Any] {
                    for data in listDatas {
                        if let convertData = data as? [String: Any] {
                            let value = JsonReader(convertData)
                            let convertValue = parser(value)
                            listValues.append(convertValue)
                        }
                    }
                    DispatchQueue.main.async {
                        completion(Result.success(listValues))
                    }
                } else {
                    DispatchQueue.main.async {
                        completion(Result.failure(JsonReaderError.listData))
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    completion(Result.failure(error))
                }
            }
        }
        task.resume()
    }
}
