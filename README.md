# Swift String Obfuscator

Are You storing more or less sensitive strings like API keys directly in the application code? For exaple like this:

![String stored in app](/github/string_in_app.png)


Do You know that's relatively easy for anyone to disassemble the application and get these strings?

![decompiled_string](/github/decompiled_string.png)



This utility convert strings annotated with a comment `//:obfuscate` into byte arrays and make them more complicated to find in disassembled code. It's not a bulletproof solution but it's better than leaving them readable at first sight.

![string_obfuscated](/github/string_obfuscated.png)



# Installation

Clone the repo and run `make install`.



# Usage

1. Install the `swift_string_obfuscator` utility

2. Annotate sensitive strings with a comment `\\:obfuscate`

3. Create a new Run Script Phase and run `swift_string_obfuscator` for files with sensitive strings. Source and target file could be the same. 

   Another possible solution is to use two files. One file, excluded from the build, with plain strings and second, with obfuscated strings included in the build.

   ```bash
   swift_string_obfuscator -s ${PROJECT_DIR}/SampleApp/API.swift -t ${PROJECT_DIR}/SampleApp/API.swift
   
   ```



## Sample

Input with plain strings.

```swift
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
```



Obfuscated output:

```swift
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
```

