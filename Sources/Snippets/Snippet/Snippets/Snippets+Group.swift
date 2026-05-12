extension Snippets {
	public struct Group<
		Output: SnippetRepresentableLiteral,
		Contents: Snippet<Output>
	>: Snippet {
		@usableFromInline
		internal let contents: Contents

		public init(
			@SnippetBuilder<Output> content: () -> Contents
		) {
			self.contents = content()
		}

		public var content: some Snippet<Output> {
			contents
		}
	}
}
