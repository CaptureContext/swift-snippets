extension Snippets {
	public struct Map<
		Output: SnippetRepresentableLiteral,
		Input: Snippet
	>: Snippet {
		@usableFromInline
		internal let input: Input

		@usableFromInline
		internal let transform: @Sendable (Input.Output) -> Output

		public init(
			_ input: Input,
			transform: @escaping @Sendable (Input.Output) -> Output
		) {
			self.input = input
			self.transform = transform
		}

		@inlinable
		public init(
			@SnippetBuilder<Input.Output> input: () -> Input,
			transform: @escaping @Sendable (Input.Output) -> Output
		) {
			self.init(
				input(),
				transform: transform
			)
		}

		@inlinable
		public func render() -> Output {
			transform(input.render())
		}
	}
}

extension Snippet {
	@inlinable
	public func map<T: SnippetRepresentableLiteral>(
		_ transform: @escaping @Sendable (Output) -> T
	) -> some Snippet<T> {
		Snippets.Map(self, transform: transform)
	}
}

extension Snippets {
	public struct FlatMap<
		Output: SnippetRepresentableLiteral,
		Result: Snippet<Output>,
		Input: Snippet
	>: Snippet {
		@usableFromInline
		internal let input: Input

		@usableFromInline
		internal let transform: @Sendable (Input.Output) -> Result

		public init(
			_ input: Input,
			@SnippetBuilder<Result.Output> transform: @escaping @Sendable (Input.Output) -> Result
		) {
			self.input = input
			self.transform = transform
		}

		@inlinable
		public init(
			@SnippetBuilder<Input.Output> input: () -> Input,
			@SnippetBuilder<Result.Output> transform: @escaping @Sendable (Input.Output) -> Result
		) {
			self.init(
				input(),
				transform: transform
			)
		}

		@inlinable
		public func render() -> Output {
			transform(input.render()).render()
		}
	}
}

extension Snippet {
	@inlinable
	public func flatMap<T: Snippet>(
		@SnippetBuilder<T.Output> _ transform: @escaping @Sendable (Output) -> T
	) -> some Snippet<T.Output> {
		Snippets.FlatMap(self, transform: transform)
	}
}
