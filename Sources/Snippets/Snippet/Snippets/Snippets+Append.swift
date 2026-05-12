import Dependencies

extension Snippets {
	public struct Append<
		Output: SnippetRepresentableLiteral,
		Source: Snippet<Output>,
		Contents: Snippet<Output>
	>: Snippet {
		@usableFromInline
		internal let source: Source

		@usableFromInline
		internal let contents: Contents

		public init(
			to source: Source,
			@SnippetBuilder<Output> content: () -> Contents
		) {
			self.source = source
			self.contents = content()
		}

		public func render() -> Output {
			let source = self.source.render()
			let contents = self.contents.render()

			return performWithoutSeparator {
				withOutputCollector { collect in
					collect([source, contents])
				}
			}
		}
	}
}

extension Snippet {
	@inlinable
	public func withPrefix(_ prefix: some Snippet<Output>) -> some Snippet<Output> {
		Snippets.Append(to: prefix) { self }
	}

	@inlinable
	public func withSuffix(_ suffix: some Snippet<Output>) -> some Snippet<Output> {
		Snippets.Append(to: self) { suffix }
	}
}

extension SnippetExpressibleByLiteral {
	@inlinable
	public func prefixed(with prefix: Self) -> Self {
		.init(snippetLiteral: Snippets.Append(to: prefix) { self }.render())
	}

	@inlinable
	public func suffixed(with suffix: Self) -> Self {
		.init(snippetLiteral: Snippets.Append(to: self) { suffix }.render())
	}
}
