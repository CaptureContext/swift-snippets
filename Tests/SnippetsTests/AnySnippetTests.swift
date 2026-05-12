import CustomDump
import Snippets
import Testing

@Suite("AnySnippet")
struct AnySnippetTests {
	@Test
	func erasesConcreteSnippetType() async throws {
		let concrete: some Snippet<String> = Snippets.Join(.const("-")) {
			"a"
			"b"
		}
		let snippet = AnySnippet(concrete)

		expectNoDifference("a-b", snippet.render())
	}

	@Test
	func erasesRepresentableValue() async throws {
		let snippet = AnySnippet<String>("value")

		expectNoDifference("value", snippet.render())
	}

	@Test
	func erasesExistentialSnippet() async throws {
		let existential: any Snippet<String> = "value".makeSnippet()
		let snippet = AnySnippet(existential)

		expectNoDifference("value", snippet.render())
	}
}
