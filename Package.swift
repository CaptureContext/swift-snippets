// swift-tools-version: 6.0

import PackageDescription

let package = Package(
	name: "swift-snippets",
	platforms: [
		.macOS(.v10_15),
		.macCatalyst(.v13),
		.iOS(.v13),
		.tvOS(.v13),
		.watchOS(.v6)
	],
	products: [
		.library(
			name: "Snippets",
			targets: ["Snippets"]
		),
	],
	dependencies: [
		.package(
			url: "https://github.com/capturecontext/swift-keypaths-extensions.git",
			.upToNextMinor(from: "0.2.2")
		),
		.package(
			url: "https://github.com/pointfreeco/swift-custom-dump.git",
			.upToNextMajor(from: "1.7.3")
		),
		.package(
			url: "https://github.com/pointfreeco/swift-dependencies.git",
			.upToNextMajor(from: "1.17.1")
		),
		.package(
			url: "https://github.com/pointfreeco/swift-issue-reporting.git",
			.upToNextMajor(from: "2.1.0")
		),
	],
	targets: [
		.target(
			name: "Snippets",
			dependencies: [
				.product(
					name: "KeyPathsExtensions",
					package: "swift-keypaths-extensions"
				),
				.product(
					name: "Dependencies",
					package: "swift-dependencies"
				),
			]
		),
		.testTarget(
			name: "SnippetsTests",
			dependencies: [
				.target(name: "Snippets"),
				.product(
					name: "IssueReportingTestSupport",
					package: "swift-issue-reporting"
				),
				.product(
					name: "CustomDump",
					package: "swift-custom-dump"
				),
			]
		),
	],
	swiftLanguageModes: [.v6]
)
