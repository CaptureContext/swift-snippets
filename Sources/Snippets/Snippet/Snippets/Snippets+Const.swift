extension Snippets {
	public struct Const<Output: SnippetRepresentableLiteral>: SnippetExpressibleByLiteral {
		@usableFromInline
		internal let literal: Output.SnippetRepresentation

		public init(_ literal: Output.SnippetRepresentation) {
			self.literal = literal
		}

		@inlinable
		public init(_ snippetLiteral: Output) {
			self.literal = snippetLiteral.makeSnippet()
		}

		@inlinable
		public init(snippetLiteral: Output) {
			self.init(snippetLiteral)
		}

		@inlinable
		public init() {
			self.init(Output.SnippetRepresentation().render())
		}

		@inlinable
		public func render() -> Output { literal.render() }

		public static func repeating(_ output: Output, count: Int) -> Self {
			return environment().performWithoutSeparator {
				self.init(
					snippetLiteral: environment(\.outputCollector)(
						Array(repeating: output, count: count)
					)
				)
			}
		}

		public static func repeating(_ literal: Self, count: Int) -> Self {
			return environment().performWithoutSeparator {
				self.init(
					snippetLiteral: environment(\.outputCollector)(
						Array(repeating: literal.render(), count: count)
					)
				)
			}
		}
	}
}

extension Snippets.Const {
	@inlinable
	public static var empty: Self { .init() }
}

extension Snippets.Const:
	ExpressibleByStringLiteral,
	ExpressibleByUnicodeScalarLiteral,
	ExpressibleByExtendedGraphemeClusterLiteral
where Output: ExpressibleByStringLiteral {}

extension Snippets.Const: Encodable where Output: Encodable {
	public func encode(to encoder: any Encoder) throws {
		try render().encode(to: encoder)
	}
}

extension Snippets.Const: Decodable where Output: Decodable {
	public init(from decoder: any Decoder) throws {
		try self.init(Output(from: decoder))
	}
}
