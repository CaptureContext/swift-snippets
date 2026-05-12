import CustomDump
import Snippets
import Testing

@Suite("SnippetRepresentable")
struct SnippetRepresentableTests {
	@Test
	func makesStringSnippetRepresentation() async throws {
		let snippet = "value".makeSnippet()

		expectNoDifference("value", snippet.render())
	}

	@Test
	func rendersSnippetThroughStaticConvenience() async throws {
		let output = String.snippet(
			Snippets.Join(.const("-")) {
				"a"
				"b"
			}
		)

		expectNoDifference("a-b", output)
	}

	@Test
	func rendersBuilderClosureThroughStaticConvenience() async throws {
		let output = String.snippet {
			"a"
			"b"
			"c"
		}

		expectNoDifference("abc", output)
	}

	@Test
	func initializesStringProtocolOutputFromStringSnippet() async throws {
		let snippet = Substring.SnippetRepresentation(
			Snippets.Join(.const("-")) {
				"a"
				"b"
			}
		)

		expectNoDifference("a-b", snippet.render())
	}
}
