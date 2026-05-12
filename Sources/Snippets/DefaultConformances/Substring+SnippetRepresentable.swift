extension Substring: SnippetRepresentableString {
	/// SnippetRepresentation for `Substring` type
	public struct SnippetRepresentation: SnippetExpressibleByLiteral, _StaticSnippetOutputCollector {
		@usableFromInline
		internal let literal: Substring

		public init(snippetLiteral: Substring) {
			self.literal = snippetLiteral
		}

		@inlinable
		public init() {
			self.init(snippetLiteral: "")
		}

		@inlinable
		public func render() -> Substring { literal }

		@inlinable
		public static func _collect(_ elements: [Output]) -> Output {
			.init(elements.joined(separator: environment(\.separator).render()))
		}
	}
}
