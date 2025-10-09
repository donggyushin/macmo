import Foundation

enum AppError: Error, LocalizedError {
    case unknown
    case notFound
    case invalidInput
    case unauthorized
    case networkError
    case databaseError(String)
    case custom(String)

    var errorDescription: String? {
        switch self {
        case .unknown:
            return "알 수 없는 오류가 발생했습니다"
        case .notFound:
            return "요청한 항목을 찾을 수 없습니다"
        case .invalidInput:
            return "잘못된 입력입니다"
        case .unauthorized:
            return "권한이 없습니다"
        case .networkError:
            return "네트워크 오류가 발생했습니다"
        case let .databaseError(message):
            return "데이터베이스 오류: \(message)"
        case let .custom(message):
            return message
        }
    }
}
