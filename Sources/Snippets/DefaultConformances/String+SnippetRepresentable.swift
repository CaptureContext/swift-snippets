extension String: SnippetRepresentableString {
	/// SnippetRepresentation for `String` type
	public struct SnippetRepresentation: SnippetExpressibleByLiteral, _StaticSnippetOutputCollector {
		@usableFromInline
		internal let literal: String

		public init(snippetLiteral: String) {
			self.literal = snippetLiteral
		}

		@inlinable
		public init() {
			self.init(snippetLiteral: "")
		}

		@inlinable
		public func render() -> String { literal }

		@inlinable
		public static func _collect(_ elements: [Output]) -> Output {
			elements.joined(separator: environment(\.separator).render())
		}
	}
}
