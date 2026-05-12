import Dependencies

extension Snippets {
	public struct Join<
		Output: SnippetRepresentableLiteral,
		Separator: Snippet<Output>,
		Contents: Snippet<Output>
	>: Snippet {
		@usableFromInline
		internal let separator: Separator

		@usableFromInline
		internal let contents: Contents

		public init(
			_ separator: Separator,
			@SnippetBuilder<Output> content: () -> Contents
		) {
			self.separator = separator
			self.contents = content()
		}

		public func render() -> Output {
			withSeparator(separator) {
				contents.render()
			}
		}
	}
}

extension Snippets.Join where Separator == Output.SnippetRepresentation {
	@inlinable
	public init(
		_ separator: Output,
		@SnippetBuilder<Output> content: () -> Contents
	) {
		self.init(
			separator.makeSnippet(),
			content: content
		)
	}

	@_disfavoredOverload
	@inlinable
	public init(
		_ separator: Separator = .init(),
		@SnippetBuilder<Output> content: () -> Contents
	) {
		self.init(
			separator,
			content: content
		)
	}
}
