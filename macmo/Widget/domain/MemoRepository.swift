
import Foundation

public protocol MemoRepository {
    func get() throws -> [MemoData]
}
