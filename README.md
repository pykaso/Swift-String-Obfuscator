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

   

   ```bash
   swift_string_obfuscator -s ${PROJECT_DIR}/SampleApp/API.swift -t ${PROJECT_DIR}/SampleApp/API.swift
   
   ```

   
