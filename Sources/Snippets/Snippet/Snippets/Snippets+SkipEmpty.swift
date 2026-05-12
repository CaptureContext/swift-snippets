extension Snippets {
	public struct SkipEmpty<
		Output: SnippetRepresentableLiteral,
		Contents: Snippet<Output>
	>: Snippet where Output: Collection {
		@usableFromInline
		internal let contents: Contents

		public init(_ contents: Contents) {
			self.contents = contents
		}

		public init(
			@SnippetBuilder<Output> content: () -> Contents
		) {
			self.init(content())
		}

		@inlinable
		public func render() -> Output {
			withNextOutputPreprocessor(
				uncheckedSendableAction { $0.filter { !$0.isEmpty } }
			) {
				contents.render()
			}
		}
	}
}

extension Snippets.SkipEmpty: SnippetExpressibleByLiteral where Contents == Output.SnippetRepresentation {
	public init(snippetLiteral: Output) {
		self.contents = snippetLiteral.makeSnippet()
	}

	public init() {
		self.init(snippetLiteral: Output.SnippetRepresentation().render())
	}
}

extension Snippet where Output: SnippetRepresentableLiteral & Collection {
	@inlinable
	public func skipEmpty() -> some Snippet<Output> {
		Snippets.SkipEmpty(self)
	}
}
