import Foundation

public protocol ImageProcessingService {
    func compressImageIfNeeded(imageData: Data, maxSizeByBytes: Int) async throws -> Data
}
