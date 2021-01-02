//
//  main.swift
//  string_obfuscator
//
//  Created by Lukas Gergel on 27.12.2020.
//

import ArgumentParser
import Foundation
import SwiftStringObfuscatorCore

struct SwiftStringObfuscator: ParsableCommand {
    static let configuration = CommandConfiguration(
        abstract: "A Swift command-line tool to convert string api-keys to byte arrays.")

    @Option(name: .shortAndLong, help: "Source file name.")
    var sourceFile: String
    
    @Option(name: .shortAndLong, help: "Target file name.")
    var targetFile: String

    mutating func run() throws {
        let inUrl = URL(fileURLWithPath: sourceFile)
        let outUrl = URL(fileURLWithPath: targetFile)
        try! StringObfuscator.obfuscateContent(sourceFile: inUrl, targetFile: outUrl)
    }
}

SwiftStringObfuscator.main()
