import Foundation

enum APIClientError: Error {
    case invalidURL
    case invalidResponse
    case requestFailed(Error)
    case invalidStatusCode(Int, Data)
    case decodingFailed(Error)
}

enum APIMethods: String {
    case get = "GET"
    case put = "PUT"
    case post = "POST"
}

final class APIClient {
    static let shared = APIClient()

    private let session: URLSession
    private let decoder: JSONDecoder

    init(session: URLSession = .shared, decoder: JSONDecoder = JSONDecoder()) {
        self.session = session
        self.decoder = decoder
    }

    func request<T: Decodable>(_ endpoint: String,
                               method: APIMethods = .get,
                               headers: [String: String] = [:],
                               body: Data? = nil) async throws -> T {
        guard let url = URL(string: endpoint) else {
            throw APIClientError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.httpBody = body

        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }

        do {
            let (data, response) = try await session.data(for: request)

            guard let httpResponse = response as? HTTPURLResponse else {
                throw APIClientError.invalidResponse
            }

            guard (200...299).contains(httpResponse.statusCode) else {
                throw APIClientError.invalidStatusCode(httpResponse.statusCode, data)
            }

            do {
                return try decoder.decode(T.self, from: data)
            } catch {
                throw APIClientError.decodingFailed(error)
            }
        } catch let error as APIClientError {
            throw error
        } catch {
            throw APIClientError.requestFailed(error)
        }
    }

    func requestData(_ endpoint: String,
                     method: String = "GET",
                     headers: [String: String] = [:],
                     body: Data? = nil) async throws -> Data {
        guard let url = URL(string: endpoint) else {
            throw APIClientError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = method
        request.httpBody = body

        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }

        do {
            let (data, response) = try await session.data(for: request)

            guard let httpResponse = response as? HTTPURLResponse else {
                throw APIClientError.invalidResponse
            }

            guard (200...299).contains(httpResponse.statusCode) else {
                throw APIClientError.invalidStatusCode(httpResponse.statusCode, data)
            }

            return data
        } catch let error as APIClientError {
            throw error
        } catch {
            throw APIClientError.requestFailed(error)
        }
    }
}

extension APIClientError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "The request URL is invalid."
        case .invalidResponse:
            return "The server returned an invalid response."
        case .requestFailed(let error):
            return error.localizedDescription
        case .invalidStatusCode(let statusCode, let data):
            if let apiMessage = APIClientError.message(from: data) {
                return apiMessage
            }
            return "Request failed with status code \(statusCode)."
        case .decodingFailed(let error):
            return "Could not read the server response: \(error.localizedDescription)"
        }
    }

    private static func message(from data: Data) -> String? {
        guard !data.isEmpty else {
            return nil
        }

        if
            let json = try? JSONSerialization.jsonObject(with: data),
            let dictionary = json as? [String: Any]
        {
            if let message = dictionary["message"] as? String {
                return message
            }

            if let error = dictionary["error"] as? String {
                return error
            }
        }

        return String(data: data, encoding: .utf8)?
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .nilIfEmpty
    }
}

private extension String {
    var nilIfEmpty: String? {
        isEmpty ? nil : self
    }
}
