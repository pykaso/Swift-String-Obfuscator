//
//  Extensions.swift
//  string_obfuscator
//
//  Created by Lukas Gergel on 27.12.2020.
//

import Foundation

extension String {
    var data: Data { .init(utf8) }
    var bytes: [UInt8] { .init(utf8) }
}
