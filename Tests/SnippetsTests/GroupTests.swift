import CustomDump
import Snippets
import Testing

@Suite("Snippets.Group")
struct GroupTests {
	@Test
	func readsGenericPreprocessorDependencyMetadata() {
		let values = String.SnippetRepresentation.environment().collectPreprocessor(["first", "second"])
		expectNoDifference(["first", "second"], values)
	}

	@Test
	func rendersGroupedBuilderContents() async throws {
		let snippet = Snippets.Group {
			"a"
			"b"
			"c"
		}

		expectNoDifference("abc", snippet.render())
	}

	@Test
	func preservesCurrentSeparatorFromParentSnippet() async throws {
		let snippet: some Snippet<String> = Snippets.Join(.const("-")) {
			"before"
			Snippets.Group {
				"a"
				"b"
			}
			"after"
		}

		expectNoDifference("before-a-b-after", snippet.render())
	}
}
