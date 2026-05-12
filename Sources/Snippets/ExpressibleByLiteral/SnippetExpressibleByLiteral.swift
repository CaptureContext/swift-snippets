public protocol SnippetExpressibleByLiteral<
	SnippetLiteralType
>: Snippet where
	Output == SnippetLiteralType
{
	associatedtype SnippetLiteralType
	init(snippetLiteral: SnippetLiteralType)

	@inlinable
	init()
}

extension SnippetExpressibleByLiteral where Output: StringProtocol {
	public init(_ snippet: some Snippet<String>) {
		let literal = Output(stringLiteral: snippet.render())
		self.init(snippetLiteral: literal)
	}
}
