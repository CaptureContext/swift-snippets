import CustomDump
import Snippets
import Testing

@Suite("Snippets.SkipEmpty")
struct SkipEmptyTests {
	@Test
	func skipsEmptyElementsWhenCollectingBuilderOutput() async throws {
		let snippets = [
			"a".makeSnippet(),
			"".makeSnippet(),
			"b".makeSnippet(),
		]
		let snippet: some Snippet<String> = Snippets.Join(.const("-")) {
			Snippets.SkipEmpty {
				snippets
			}
			"c"
		}

		expectNoDifference("a-b-c", snippet.render())
	}

	@Test
	func skipsEmptyElementsFromWrappedSnippet() async throws {
		let snippets = [
			"a".makeSnippet(),
			"".makeSnippet(),
			"b".makeSnippet(),
		]
		let snippet: some Snippet<String> = Snippets.Join(.const("-")) {
			snippets
		}
		.skipEmpty()

		expectNoDifference("a-b", snippet.render())
	}

	@Test
	func conformsToLiteralSnippet() async throws {
		let snippet = Snippets.SkipEmpty<String, String.SnippetRepresentation>(
			snippetLiteral: "value"
		)

		expectNoDifference("value", snippet.render())
	}

	@Test
	func rendersEmptyDefault() async throws {
		let snippet = Snippets.SkipEmpty<String, String.SnippetRepresentation>()

		expectNoDifference("", snippet.render())
	}
}
