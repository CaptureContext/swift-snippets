extension SnippetRepresentableLiteral {
	public static func const(_ value: Snippets.Const<Self>) -> Self {
		value.render()
	}
}

extension Snippets.Const {
	@inlinable
	public init(_ other: Self) {
		self = other
	}
}

extension Snippets.Const where Output: SnippetRepresentableString {
	/// `"\n"`
	@inlinable
	public static var newline: Self {
		return .newlines(1)
	}

	/// `"\n" * count`
	@inlinable
	public static func newlines(_ count: Int) -> Self {
		.repeating("\n", count: count)
	}

	/// `" "`
	@inlinable
	public static var whitespace: Self {
		return .whitespaces(1)
	}

	/// `" " * count`
	@inlinable
	public static func whitespaces(_ count: Int) -> Self {
		.repeating(" ", count: count)
	}

	/// `"\t"`
	@inlinable
	public static var tab: Self {
		return .tabs(1)
	}

	/// `"\t" * count`
	@inlinable
	public static func tabs(_ count: Int) -> Self {
		.repeating("\t", count: count)
	}
	/// `"\""`
	@inlinable
	public static var quote: Self {
		return .quotes(1)
	}

	/// `"\"" * count`
	@inlinable
	public static func quotes(_ count: Int) -> Self {
		.repeating("\"", count: count)
	}

	/// ``"`"``
	@inlinable
	public static var backtick: Self {
		return .backticks(1)
	}

	// ``"`" * count``
	@inlinable
	public static func backticks(_ count: Int) -> Self {
		.repeating("`", count: count)
	}

	/// `":"`
	@inlinable
	public static var colon: Self {
		return .colons(1)
	}

	/// `":" * count`
	@inlinable
	public static func colons(_ count: Int) -> Self {
		.repeating(":", count: count)
	}

	/// `"."`
	@inlinable
	public static var dot: Self {
		return .dots(1)
	}

	/// `"." * count`
	@inlinable
	public static func dots(_ count: Int) -> Self {
		.repeating(".", count: count)
	}

	/// `","`
	@inlinable
	public static var comma: Self {
		return .commas(1)
	}


	/// `"," * count`
	@inlinable
	public static func commas(_ count: Int) -> Self {
		.repeating(",", count: count)
	}

	/// `"["`
	@inlinable
	public static var leftBracket: Self {
		return .init(snippetLiteral: "[")
	}

	/// `"]"`
	@inlinable
	public static var rightBracket: Self {
		return .init(snippetLiteral: "]")
	}

	/// `"{"`
	@inlinable
	public static var leftBrace: Self {
		return .init(snippetLiteral: "{")
	}

	/// `"}"`
	@inlinable
	public static var rightBrace: Self {
		return .init(snippetLiteral: "}")
	}

	/// `"("`
	@inlinable
	public static var leftParenthesis: Self {
		return .init(snippetLiteral: "(")
	}

	/// `")"`
	@inlinable
	public static var rightParenthesis: Self {
		return .init(snippetLiteral: ")")
	}

	/// `"<"`
	@inlinable
	public static var lessThan: Self {
		return .init(snippetLiteral: "<")
	}

	/// `">"`
	@inlinable
	public static var greaterThan: Self {
		return .init(snippetLiteral: ">")
	}

	/// `"="`
	@inlinable
	public static var equal: Self {
		return .equals(count: 1)
	}

	/// `"=" * count`
	@inlinable
	public static func equals(count: Int = 2) -> Self {
		return .repeating("=", count: count)
	}
}
