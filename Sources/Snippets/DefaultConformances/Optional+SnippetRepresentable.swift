extension Optional: SnippetRepresentable where Wrapped: SnippetRepresentableLiteral {
	/// SnippetRepresentation for `Optional` type
	public struct SnippetRepresentation: SnippetExpressibleByLiteral, _StaticSnippetOutputCollector {
		@usableFromInline
		internal let literal: Wrapped.SnippetRepresentation?

		public init(snippetLiteral: Wrapped?) {
			self.literal = snippetLiteral?.makeSnippet()
		}

		@inlinable
		public init() {
			self.init(snippetLiteral: nil)
		}

		@inlinable
		public func render() -> Wrapped? { literal?.render() }

		@inlinable
		public static func _collect(_ elements: [Output]) -> Output {
			Wrapped.SnippetRepresentation._collect(elements.compactMap { $0 })
		}
	}
}

extension Optional: SnippetRepresentableLiteral where Wrapped: SnippetRepresentableLiteral {}
