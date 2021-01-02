import XCTest
@testable import SwiftStringObfuscatorCore
import SwiftSyntax

final class SwiftStringObfuscatorTests: XCTestCase {
    
    let sampleFileURL = urlTempString("""
    //:obfuscate
    let apiKey = "something-secret"

    //:obfuscate
    let apiKey2="something-secret-without-spaces"

    //:obfuscate
    //useless line, only for test purposes

    let nonObfuscated: String = "non-obfuscated-string"

    struct XStruct {
        let x: Int
        
        //:obfuscate
        let apiKey3 = "key-in-struct"
        
        //:obfuscate
        var param: String {
            return "key-in-computed-property"
        }
        
        //:obfuscate
        var dynamic2: String { "key-in-computed-property-2" }
    }

    class Y {
        //:obfuscate
        static let keyInClass: String = "api-key-in-class"

        func apiFuncParam(_ key: String) { return }
    }

    func test() {
        let testClass = Y()
        //:obfuscate
        testClass.apiFuncParam("api_key_func_param")
    }
    """)
    
    let sampleObfuscatedOutput = """
    //:obfuscate
    let apiKey = String(bytes: [115,111,109,101,116,104,105,110,103,45,115,101,99,114,101,116], encoding: .utf8)

    //:obfuscate
    let apiKey2=String(bytes: [115,111,109,101,116,104,105,110,103,45,115,101,99,114,101,116,45,119,105,116,104,111,117,116,45,115,112,97,99,101,115], encoding: .utf8)

    //:obfuscate
    //useless line, only for test purposes

    let nonObfuscated: String = "non-obfuscated-string"

    struct XStruct {
        let x: Int
        
        //:obfuscate
        let apiKey3 = String(bytes: [107,101,121,45,105,110,45,115,116,114,117,99,116], encoding: .utf8)
        
        //:obfuscate
        var param: String {
            return String(bytes: [107,101,121,45,105,110,45,99,111,109,112,117,116,101,100,45,112,114,111,112,101,114,116,121], encoding: .utf8)
        }
        
        //:obfuscate
        var dynamic2: String { String(bytes: [107,101,121,45,105,110,45,99,111,109,112,117,116,101,100,45,112,114,111,112,101,114,116,121,45,50], encoding: .utf8)}
    }

    class Y {
        //:obfuscate
        static let keyInClass: String = String(bytes: [97,112,105,45,107,101,121,45,105,110,45,99,108,97,115,115], encoding: .utf8)

        func apiFuncParam(_ key: String) { return }
    }

    func test() {
        let testClass = Y()
        //:obfuscate
        testClass.apiFuncParam(String(bytes: [97,112,105,95,107,101,121,95,102,117,110,99,95,112,97,114,97,109], encoding: .utf8))
    }
    """
    
    func testObfuscator() throws {
        let obfuscated = try? StringObfuscator.getObfuscatedContent(for: sampleFileURL)
        XCTAssertEqual(obfuscated, sampleObfuscatedOutput)
    }

    static var allTests = [("testObfuscator", testObfuscator)]
    
    static func urlTempString(_ str: String) -> URL {
        let directory = NSTemporaryDirectory()
        let fileName = NSUUID().uuidString
        let fullURL = NSURL.fileURL(withPathComponents: [directory, fileName])!
        
        try! str.write(to: fullURL, atomically: true, encoding: .utf8)
        
        return fullURL
    }
}
