extension Snippets {
	public struct Inline<Output: SnippetRepresentableLiteral>: Snippet {
		@usableFromInline
		internal let output: @Sendable () -> Output

		public init(render: @escaping @Sendable () -> Output) {
			self.output = render
		}

		@inlinable
		public func render() -> Output { output() }
	}
}
