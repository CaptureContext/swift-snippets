// swift-tools-version: 6.0

import PackageDescription

// Match the package identity used by Point-Free's manifests for this compiler.
#if compiler(>=6.4)
let issueReportingPackage: String = "swift-issue-reporting"
let issueReportingVersion: Version = "2.1.0"
#else
let issueReportingPackage: String = "xctest-dynamic-overlay"
let issueReportingVersion: Version = "1.13.0"
#endif

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
			url: "https://github.com/pointfreeco/\(issueReportingPackage).git",
			.upToNextMajor(from: issueReportingVersion)
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
					package: issueReportingPackage
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
