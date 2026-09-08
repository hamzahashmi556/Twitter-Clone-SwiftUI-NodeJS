//
//  ImageUploader.swift
//  Twitter Clone
//
//  Created by PSG-MDU-HAMZA on 07/09/2026.
//

import Foundation

struct ImageUploader {
    
    static func uploadMultipart<T: Decodable>(
        urlPath: String,
        fileData: Data,
        fileName: String,
        paramName: String,
    ) async throws -> T {
        
        guard let url = URL(string: urlPath) else {
            throw APIClientError.invalidURL
        }

        let boundary = UUID().uuidString
        let session = URLSession.shared

        var request = URLRequest(url: url)
        request.httpMethod = APIMethods.post.rawValue
        
        // Headers
        if let jwt = UserDefaults.jwt {
            request.setValue(jwt, forHTTPHeaderField: "Authorization")
        }
        request.setValue(
            "multipart/form-data; boundary=\(boundary)",
            forHTTPHeaderField: "Content-Type"
        )

        var body = Data()

        // File
        body.append("--\(boundary)\r\n")
        body.append("Content-Disposition: form-data; name=\"\(paramName)\"; filename=\"\(fileName)\"\r\n")
        body.append("Content-Type: image/png\r\n\r\n")
        body.append(fileData)
        
        // End boundary
        body.append("\r\n--\(boundary)--\r\n")

        request.httpBody = body

        do {
            let (data, response) = try await URLSession.shared.data(for: request)

            guard let httpResponse = response as? HTTPURLResponse else {
                throw APIClientError.invalidResponse
            }

            guard (200...299).contains(httpResponse.statusCode) else {
                throw APIClientError.invalidStatusCode(
                    httpResponse.statusCode,
                    data
                )
            }
            
            return try JSONDecoder().decode(T.self, from: data)

        } catch let error as APIClientError {
            throw error
        } catch {
            throw APIClientError.requestFailed(error)
        }
    }
}

private extension Data {
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
}
