extension Snippets {
	public struct UnsafeSendable<
		Output: SnippetRepresentableLiteral
	>: SnippetExpressibleByLiteral {

		@usableFromInline
		internal let underlying: Underlying

		public init(_ literal: Output) {
			self.underlying = .const(.init(snippetLiteral: literal))
		}

		@inlinable
		public init(snippetLiteral: Output) {
			self.init(snippetLiteral)
		}

		@inlinable
		public init() {
			self.init(snippetLiteral: Output.SnippetRepresentation().render())
		}

		public init(render: @escaping () -> Output) {
			self.underlying = .inline(.init(render: render))
		}

		@inlinable
		public func render() -> Output { underlying.render() }

		@usableFromInline
		internal enum Underlying: Snippet {
			case const(Const)
			case inline(Inline)

			@usableFromInline
			internal func render() -> Output {
				switch self {
				case let .const(snippet): snippet.render()
				case let .inline(snippet): snippet.render()
				}
			}
		}

		@usableFromInline
		internal struct Const: SnippetExpressibleByLiteral {
			@usableFromInline
			nonisolated(unsafe) internal let output: Output

			@usableFromInline
			internal init(snippetLiteral: Output) {
				self.output = snippetLiteral
			}

			@usableFromInline
			internal init() {
			 self.init(snippetLiteral: Output.SnippetRepresentation().render())
		 }

			@usableFromInline
			internal func render() -> Output { output }
		}

		@usableFromInline
		internal struct Inline: Snippet {
			@usableFromInline
			nonisolated(unsafe) internal let output: () -> Output

			@usableFromInline
			internal init(render: @escaping () -> Output) {
				self.output = render
			}

			@usableFromInline
			internal func render() -> Output {
				output()
			}
		}
	}
}
