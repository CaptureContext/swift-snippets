import CustomDump
import Snippets
import Testing

@Suite("Snippets.Bracket")
struct BracketTests {
	@Test
	func rendersSymmetricBrackets() async throws {
		let brackets = Snippets.Bracket<String, String.SnippetRepresentation>.Brackets("`")
		let snippet = Snippets.Bracket("value".makeSnippet(), in: brackets)

		expectNoDifference("`value`", snippet.render())
	}

	@Test
	func rendersPairedBracketsFromBuilderClosure() async throws {
		let value: String = .snippet {
			"value"
		}
		let snippet = Snippets.Bracket(value.makeSnippet(), in: .parenthesis)

		expectNoDifference("(value)", snippet.render())
	}

	@Test
	func rendersStringBracketDefaults() async throws {
		expectNoDifference("``value``", Snippets.Bracket("value".makeSnippet(), in: .backticks(2)).render())
		expectNoDifference(#""value""#, Snippets.Bracket("value".makeSnippet(), in: .quotes()).render())
		expectNoDifference("[value]", Snippets.Bracket("value".makeSnippet(), in: .brackets).render())
		expectNoDifference("{value}", Snippets.Bracket("value".makeSnippet(), in: .braces).render())
		expectNoDifference("(value)", Snippets.Bracket("value".makeSnippet(), in: .parenthesis).render())
		expectNoDifference("<value>", Snippets.Bracket("value".makeSnippet(), in: .diamond).render())
	}

	@Test
	func combinesInnerBrackets() async throws {
		let brackets = Snippets.Bracket<String, String.SnippetRepresentation>.Brackets.braces
			.withInner(Snippets.Bracket<String, String.SnippetRepresentation>.Brackets.parenthesis)
		let snippet = Snippets.Bracket("value".makeSnippet(), in: brackets)

		expectNoDifference("{(value)}", snippet.render())
	}

	@Test
	func combinesOuterBrackets() async throws {
		let brackets = Snippets.Bracket<String, String.SnippetRepresentation>.Brackets.braces
			.withOuter(Snippets.Bracket<String, String.SnippetRepresentation>.Brackets.parenthesis)
		let snippet = Snippets.Bracket("value".makeSnippet(), in: brackets)

		expectNoDifference("({value})", snippet.render())
	}
}
