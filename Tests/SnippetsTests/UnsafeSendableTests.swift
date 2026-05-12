import CustomDump
import Snippets
import Testing

@Suite("Snippets.UnsafeSendable")
struct UnsafeSendableTests {
	@Test
	func rendersLiteralOutput() async throws {
		let snippet = Snippets.UnsafeSendable<String>("value")

		expectNoDifference("value", snippet.render())
	}

	@Test
	func rendersEmptyDefault() async throws {
		let snippet = Snippets.UnsafeSendable<String>()

		expectNoDifference("", snippet.render())
	}

	@Test
	func rendersInlineOutput() async throws {
		let snippet = Snippets.UnsafeSendable<String> {
			"dynamic"
		}

		expectNoDifference("dynamic", snippet.render())
	}
}

