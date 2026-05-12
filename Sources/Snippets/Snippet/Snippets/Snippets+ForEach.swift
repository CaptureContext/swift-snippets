extension Snippets {
	public struct ForEach<
		Output: SnippetRepresentableLiteral,
		Element: Sendable,
		ElementSnippet: Snippet<Output>
	>: Snippet {
		@usableFromInline
		internal let elements: [ElementSnippet]

		public init<S: Sequence<Element>>(
			_ sequence: S,
			@SnippetBuilder<Output> content: (Element) -> ElementSnippet
		) {
			self.elements = sequence.map(content)
		}

		@inlinable
		public var content: some Snippet<Output> {
			elements
		}
	}
}
