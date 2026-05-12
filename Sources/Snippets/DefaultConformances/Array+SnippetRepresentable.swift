extension Array: SnippetRepresentable where Element: SnippetRepresentableLiteral {
	/// SnippetRepresentation for `Array` type
	public struct SnippetRepresentation: SnippetExpressibleByLiteral, _StaticSnippetOutputCollector {
		@usableFromInline
		internal let literal: [Element.SnippetRepresentation]

		public init(snippetLiteral: [Element]) {
			self.literal = snippetLiteral.map { $0.makeSnippet() }
		}

		@inlinable
		public init() {
			self.init(snippetLiteral: [])
		}

		@inlinable
		public func render() -> [Element] { literal.map { $0.render() } }

		@inlinable
		public static func _collect(_ elements: [Output]) -> Output {
			.init(elements.joined(separator: environment(\.separator).render()))
		}
	}
}

extension Array: SnippetRepresentableLiteral where Element: SnippetRepresentableLiteral {}
