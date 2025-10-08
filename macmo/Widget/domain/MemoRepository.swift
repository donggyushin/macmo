
import Foundation

public protocol MemoRepository {
    func get() throws -> [MemoData]
    func getPlaceholder() throws -> [MemoData]
}
