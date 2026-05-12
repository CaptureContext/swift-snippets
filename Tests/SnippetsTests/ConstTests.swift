import Foundation
import CustomDump
import Snippets
import Testing

@Suite("Snippets.Const")
struct ConstTests {
	@Test
	func rendersStringLiteral() async throws {
		let snippet: Snippets.Const<String> = "value"

		expectNoDifference("value", snippet.render())
	}

	@Test
	func rendersEmptyDefault() async throws {
		expectNoDifference("", Snippets.Const<String>().render())
		expectNoDifference("", Snippets.Const<String>.empty.render())
	}

	@Test
	func repeatsOutputWithoutCurrentSeparator() async throws {
		let snippet: some Snippet<String> = Snippets.Join(.const("-")) {
			"prefix"
			Snippets.Const<String>.repeating("x", count: 3)
			"suffix"
		}

		expectNoDifference("prefix-xxx-suffix", snippet.render())
	}

	@Test
	func repeatsConstWithoutCurrentSeparator() async throws {
		let literal: Snippets.Const<String> = "ab"
		let snippet: some Snippet<String> = Snippets.Join(.const("|")) {
			"start"
			Snippets.Const<String>.repeating(literal, count: 2)
			"end"
		}

		expectNoDifference("start|abab|end", snippet.render())
	}

	@Test
	func encodesAndDecodesOutput() async throws {
		let encoder = JSONEncoder()
		let decoder = JSONDecoder()
		let original: Snippets.Const<String> = "encoded"

		let data = try encoder.encode(original)
		let decoded = try decoder.decode(Snippets.Const<String>.self, from: data)

		expectNoDifference(#""encoded""#, String(decoding: data, as: UTF8.self))
		expectNoDifference("encoded", decoded.render())
	}
}
