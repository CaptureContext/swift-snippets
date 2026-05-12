public struct AnySnippet<Output: SnippetRepresentableLiteral>: Snippet {
	@usableFromInline
	internal let underlying: any Snippet<Output>

	public init(_ underlying: any Snippet<Output>) {
		self.underlying = underlying
	}

	@inlinable
	public init(
		@SnippetBuilder<Output> content: () -> some Snippet<Output>
	) {
		self.init(content())
	}

	@_disfavoredOverload
	public init<R: SnippetRepresentable>(
		_ representable: R
	) where R.SnippetRepresentation.Output == Output {
		self.init(representable.makeSnippet())
	}

	@inlinable
	public func render() -> Output {
		underlying.render()
	}
}

extension Snippet {
	@inlinable
	public func eraseToAnySnippet() -> AnySnippet<Output> {
		AnySnippet(self)
	}
}
