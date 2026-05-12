import Dependencies
import KeyPathsExtensions

/// Convenience type for creating snippet environment keys
///
/// Final snippets are often designed as "somewhat pure" functions, so there is no
/// need for specifying separate different `live`, `test` and `preview` variants
///
/// Snippet environment is a way to implicitly pass arguments to lower level snippets
public protocol SnippetEnvironmentKey<Output, Value>: DependencyKey where Value: Sendable {
	associatedtype Output: SnippetRepresentableLiteral
	static var defaultValue: Value { get }
}

extension SnippetEnvironmentKey {
	public static var liveValue: Value { defaultValue }
	public static var testValue: Value { defaultValue }
	public static var previewValue: Value { defaultValue }
}

extension Snippet {
	/// Returns current environment for the snippet
	///
	/// Should only be used in `render()` function call stack
	@inlinable
	public static func environment(
		fileID: StaticString = #fileID,
		filePath: StaticString = #filePath,
		line: UInt = #line,
		column: UInt = #column
	) -> SnippetEnvironmentValues<Output> {
		SnippetEnvironmentValues(
			fileID: fileID,
			filePath: filePath,
			line: line,
			column: column
		)
	}

	/// Returns a value from current environment for the snippet
	///
	/// Should only be used in `render()` function call stack
	@inlinable
	public static func environment<Value>(
		_ keyPath: KeyPath<SnippetEnvironmentValues<Output>, Value>,
		fileID: StaticString = #fileID,
		filePath: StaticString = #filePath,
		line: UInt = #line,
		column: UInt = #column
	) -> Value {
		environment()[keyPath: keyPath]
	}
}

/// Namespace for declaring values for snippet environment
///
/// Doesn't hold any values except of creation context data,
/// actual values are meant to be stored elsewhere, for example
/// in `DependencyValues`
public struct SnippetEnvironmentValues<Output: SnippetRepresentableLiteral>: Sendable {
	@usableFromInline
	let fileID: StaticString

	@usableFromInline
	let filePath: StaticString

	@usableFromInline
	let line: UInt

	@usableFromInline
	let column: UInt

	@usableFromInline
	init(
		fileID: StaticString = #fileID,
		filePath: StaticString = #filePath,
		line: UInt = #line,
		column: UInt = #column
	) {
		self.fileID = fileID
		self.filePath = filePath
		self.line = line
		self.column = column
	}

	/// Convenient accessor for dependency values
	public func dependency<Value>(_ keyPath: KeyPath<DependencyValues, Value>) -> Value {
		@Dependency(
			keyPath.unsafeSendable(),
			fileID: fileID,
			filePath: filePath,
			line: line,
			column: column
		)
		var value

		return value
	}
}
