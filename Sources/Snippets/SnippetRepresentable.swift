/// Type that can be represented by a snippet
///
/// - Note: If you want to construct a custom type using snippets,
///         take a look at ``SnippetRepresentableLiteral`` protocol
public protocol SnippetRepresentable<
	SnippetRepresentation
> {
	associatedtype SnippetRepresentation: Snippet
	func makeSnippet() -> SnippetRepresentation
}

extension SnippetRepresentable
where SnippetRepresentation: SnippetExpressibleByLiteral<Self> {
	public func makeSnippet() -> SnippetRepresentation {
		SnippetRepresentation(snippetLiteral: self)
	}
}

/// Requirement for `SnippetRepresentation` of  ``SnippetRepresentableLiteral``
public protocol _StaticSnippetOutputCollector<Output>: Snippet {
	/// Declare this function while implementing snippets support for custom types
	///
	/// Do not call this function directly, use `withOutputCollector(perform:)`
	/// method to get current collector instead.
	///
	/// See existing implementations for `String` and `Optional` if you gonna
	/// implement support for custom types
	static func _collect(_ elements: [Output]) -> Output
}

/// Protocol that marks type as snippet compatible output
///
/// See existing implementations for `String` and `Optional`
public protocol SnippetRepresentableLiteral: SnippetRepresentable where
	SnippetRepresentation: _StaticSnippetOutputCollector<Self>,
	SnippetRepresentation: SnippetExpressibleByLiteral<Self>
{}

/// Convenience umbrella protocol for declaring StringProtocol-constraint snippets
///
/// Example:
/// ```swift
/// public struct Indent<
/// 	Output: SnippetRepresentableString, // ← Output is constraint to SnippetRepresentableString
/// 	Contents: Snippet<Output>
/// >: Snippet {
/// 	@usableFromInline
/// 	internal let contents: Contents
///
/// 	public init(
/// 		@SnippetBuilder<Output> content: () -> Contents
/// 	) {
/// 		self.contents = content()
/// 	}
///
/// 	@inlinable
/// 	public func render() -> Output {
/// 		let indentor = "\t"
/// 		let source = contents.render()
/// 		let lines = source.components(separatedBy: .newlines)
/// 		let indented = lines.map { line in
/// 			if line.isEmpty { line }
/// 			else { indentor.appending(line) }
/// 		}
/// 		let result = indented.joined(separator: "\n")
/// 		return Output(stringLiteral: result)
/// 	}
/// }
/// ```
public protocol SnippetRepresentableString: SnippetRepresentableLiteral, StringProtocol {}

extension SnippetRepresentable {
	/// Renders provided snippet and returns the result
	@inlinable
	public static func snippet(
		@SnippetBuilder<Self> content: () -> some Snippet<Self>
	) -> Self {
		return .snippet(content())
	}

	/// Renders provided snippet and returns the result
	@inlinable
	public static func snippet(
		_ snippet: some Snippet<Self>
	) -> Self {
		snippet.render()
	}
}
