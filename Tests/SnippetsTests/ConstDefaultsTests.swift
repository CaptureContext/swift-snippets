import CustomDump
import Snippets
import Testing

@Suite("Snippets.Const defaults")
struct ConstDefaultsTests {
	@Test
	func rendersWhitespaceDefaults() async throws {
		expectNoDifference("\n", Snippets.Const<String>.newline.render())
		expectNoDifference("\n\n\n", Snippets.Const<String>.newlines(3).render())
		expectNoDifference(" ", Snippets.Const<String>.whitespace.render())
		expectNoDifference("    ", Snippets.Const<String>.whitespaces(4).render())
		expectNoDifference("\t", Snippets.Const<String>.tab.render())
		expectNoDifference("\t\t", Snippets.Const<String>.tabs(2).render())
	}

	@Test
	func rendersDelimiterDefaults() async throws {
		expectNoDifference(#"""#, Snippets.Const<String>.quote.render())
		expectNoDifference("\"\"\"", Snippets.Const<String>.quotes(3).render())
		expectNoDifference("`", Snippets.Const<String>.backtick.render())
		expectNoDifference("``", Snippets.Const<String>.backticks(2).render())
		expectNoDifference(":", Snippets.Const<String>.colon.render())
		expectNoDifference("::", Snippets.Const<String>.colons(2).render())
		expectNoDifference(".", Snippets.Const<String>.dot.render())
		expectNoDifference("...", Snippets.Const<String>.dots(3).render())
		expectNoDifference(",", Snippets.Const<String>.comma.render())
		expectNoDifference(",,", Snippets.Const<String>.commas(2).render())
	}

	@Test
	func rendersBracketDefaults() async throws {
		expectNoDifference("[", Snippets.Const<String>.leftBracket.render())
		expectNoDifference("]", Snippets.Const<String>.rightBracket.render())
		expectNoDifference("{", Snippets.Const<String>.leftBrace.render())
		expectNoDifference("}", Snippets.Const<String>.rightBrace.render())
		expectNoDifference("(", Snippets.Const<String>.leftParenthesis.render())
		expectNoDifference(")", Snippets.Const<String>.rightParenthesis.render())
		expectNoDifference("<", Snippets.Const<String>.lessThan.render())
		expectNoDifference(">", Snippets.Const<String>.greaterThan.render())
	}

	@Test
	func rendersEqualsDefaults() async throws {
		expectNoDifference("=", Snippets.Const<String>.equal.render())
		expectNoDifference("==", Snippets.Const<String>.equals().render())
		expectNoDifference("===", Snippets.Const<String>.equals(count: 3).render())
	}

	@Test
	func rendersConstConvenienceOnOutput() async throws {
		expectNoDifference(",,,", String.const(.commas(3)))
	}
}
