import Foundation

extension SnippetExpressibleByLiteral where Output: ExpressibleByStringLiteral {
	public typealias StringLiteralType = Output.StringLiteralType
	public typealias UnicodeScalarLiteralType = Output.UnicodeScalarLiteralType
	public typealias ExtendedGraphemeClusterLiteralType = Output.ExtendedGraphemeClusterLiteralType
	
	public init(stringLiteral value: Output.StringLiteralType) {
		self.init(snippetLiteral: .init(stringLiteral: value))
	}

	public init(unicodeScalarLiteral value: Output.UnicodeScalarLiteralType) {
		self.init(snippetLiteral: .init(unicodeScalarLiteral: value))
	}

	public init(extendedGraphemeClusterLiteral value: Output.ExtendedGraphemeClusterLiteralType) {
		self.init(snippetLiteral: .init(extendedGraphemeClusterLiteral: value))
	}
}
