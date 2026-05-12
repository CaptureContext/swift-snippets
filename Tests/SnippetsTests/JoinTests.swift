import CustomDump
import Snippets
import Testing

@Suite("Snippets.Join")
struct JoinTests {
	@Test
	func joinsBuilderContentsWithDefaultEmptySeparator() async throws {
		let snippet = Snippets.Join {
			"a"
			"b"
			"c"
		}

		expectNoDifference("abc", snippet.render())
	}

	@Test
	func joinsBuilderContentsWithOutputSeparator() async throws {
		let snippet: some Snippet<String> = Snippets.Join(.const(", ")) {
			"a"
			"b"
			"c"
		}

		expectNoDifference("a, b, c", snippet.render())
	}

	@Test
	func joinsBuilderContentsWithSnippetSeparator() async throws {
		let separator = Snippets.Const<String>.whitespace
			.withPrefix("|".makeSnippet())
			.withSuffix("|".makeSnippet())
		let snippet = Snippets.Join(separator) {
			"a"
			"b"
			"c"
		}

		expectNoDifference("a| |b| |c", snippet.render())
	}

	@Test
	func restoresOuterSeparatorAfterNestedJoin() async throws {
		let snippet: some Snippet<String> = Snippets.Join(.const(",")) {
			"a"
			Snippets.Join(.const("-")) {
				"b"
				"c"
			}
			"d"
		}

		expectNoDifference("a,b-c,d", snippet.render())
	}
}
