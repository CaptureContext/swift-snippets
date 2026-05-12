/// A protocol that describes how to build an output
///
/// There are 2 primary APIs for this protocol
///
/// - Composition API:
///
/// ```swift
/// public struct Lowercased<
/// 	Output: SnippetRepresentableString, // or more generic `SnippetRepresentableLiteral`
/// 	Child: Snippet<Output>
/// >: Snippet {
/// 	@usableFromInline
/// 	internal let child: Child
///
/// 	public init(
/// 		@SnippetBuilder<Output> child: () -> Child,
/// 	) {
/// 		self.child = child()
/// 	}
///
/// 	@inlinable
/// 	public var content: some Snippet<Output> {
/// 		child.map { Output(stringLiteral: $0.lowercased()) }
/// 	}
/// }
/// ```
///
/// - Imperative API
///
/// ```swift
/// public struct Lowercased<
/// 	Output: SnippetRepresentableString, // or more generic `SnippetRepresentableLiteral`
/// 	Child: Snippet<Output>
/// >: Snippet {
/// 	@usableFromInline
/// 	internal let child: Child
///
/// 	public init(
/// 		@SnippetBuilder<Output> child: () -> Child,
/// 	) {
/// 		self.child = child()
/// 	}
///
/// 	@inlinable
/// 	public func render() -> Output {
/// 		Output(stringLiteral: child.render().lowercased())
/// 	}
/// }
/// ```
public protocol Snippet<Output>:
	Sendable,
	SnippetRepresentable
where
	SnippetRepresentation == Self
{
	associatedtype Output: SnippetRepresentableLiteral

	/// A type representing the content of this snippet.
	///
	/// When you create a custom snippet by implementing the ``snippet-swift.property``, Swift infers
	/// this type from the value returned.
	///
	/// If you create a custom snippet by implementing the ``render()``, Swift
	/// infers this type to be `Never`.
	associatedtype Content: Snippet

	/// Renders the snippet
	func render() -> Output

	/// The content and behavior of a snippet that is composed from other snippets.
	///
	/// In the body of a snippet one can compose many snippet together, which will be run in order,
	/// from top to bottom
	///
	/// Do not invoke this property directly.
	///
	/// > Important: if your snippet implements the ``render()`` method, it will
	/// > take precedence over this property, and only ``reduce()`` will be called
	@SnippetBuilder<Output>
	var content: Content { get }
}

extension Snippet {
	public func makeSnippet() -> SnippetRepresentation { self }
}

extension Snippet where Content: Snippet<Output> {
	/// Invokes the ``Snippet``'s implementation of ``render()``.
	@inlinable
	@_optimize(none)
	public func render() -> Output {
		self.content.render()
	}
}

extension Snippet where Content == Never.SnippetRepresentation {
	/// A non-existent body.
	///
	/// > Warning: Do not invoke this property directly. It will trigger a fatal error at runtime.
	@_transparent
	public var content: Content {
		._fatalError("'\(Self.self)' has no body.")
	}
}

extension Never: SnippetRepresentableLiteral {
	public struct SnippetRepresentation: SnippetExpressibleByLiteral, _StaticSnippetOutputCollector {

		public init(snippetLiteral: Never) {
			fatalError("Unreachable")
		}

		public init() {
			self = ._fatalError("'\(Self.self)' has no body.")
		}

		public var content: some Snippet<Never> {
			Self._fatalError("'\(Self.self)' has no body.")
		}

		@_transparent
		public func render() -> Never {
			fatalError("Unreachable")
		}

		@_transparent
		public func makeSnippet() -> Self {
			fatalError("Unreachable")
		}

		@_transparent
		public static func _fatalError(_ message: String) -> Self {
			fatalError(message)
		}

		public static func _collect(_ elements: [Output]) -> Output {
			fatalError("Unreachable")
		}
	}
}
