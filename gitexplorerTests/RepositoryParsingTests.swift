//
//  RepositoryParsingTests.swift
//  gitexplorerTests
//

import Foundation
import Testing
@testable import gitexplorer

struct RepositoryParsingTests {
    /// Decodifica di una risposta di ricerca e mapping dei campi snake_case.
    @Test func decodesSearchResponse() throws {
        let json = """
        {
          "total_count": 2,
          "items": [
            {
              "id": 1,
              "name": "swift",
              "full_name": "swiftlang/swift",
              "owner": { "login": "swiftlang", "avatar_url": "https://example.com/a.png" },
              "description": "The Swift Programming Language",
              "language": "C++",
              "forks_count": 10,
              "open_issues_count": 20,
              "stargazers_count": 30
            }
          ]
        }
        """.data(using: .utf8)!

        let response = try JSONDecoder().decode(SearchResponse.self, from: json)

        #expect(response.totalCount == 2)
        #expect(response.items.count == 1)

        let repository = try #require(response.items.first)
        #expect(repository.organization == "swiftlang")
        #expect(repository.repositoryName == "swift")
        #expect(repository.displayTitle == "swiftlang / swift")
        #expect(repository.language == "C++")
        #expect(repository.forksCount == 10)
        #expect(repository.openIssuesCount == 20)
        #expect(repository.stargazersCount == 30)
        #expect(repository.owner.avatarURL == URL(string: "https://example.com/a.png"))
    }

    /// La release espone il `tag_name`.
    @Test func decodesRelease() throws {
        let json = #"{ "tag_name": "v5.50.2" }"#.data(using: .utf8)!
        let release = try JSONDecoder().decode(Release.self, from: json)
        #expect(release.tagName == "v5.50.2")
    }

    /// Descrizione, linguaggio e avatar assenti (null) non fanno fallire il decoding.
    @Test func handlesNullOptionalFields() throws {
        let json = """
        {
          "id": 5, "name": "x", "full_name": "org/x",
          "owner": { "login": "org", "avatar_url": null },
          "description": null, "language": null,
          "forks_count": 0, "open_issues_count": 0, "stargazers_count": 0
        }
        """.data(using: .utf8)!

        let repository = try JSONDecoder().decode(Repository.self, from: json)
        #expect(repository.description == nil)
        #expect(repository.language == nil)
        #expect(repository.owner.avatarURL == nil)
        #expect(repository.displayDescription == nil)
    }
}
