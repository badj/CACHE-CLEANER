# Stremio Cache Cleaner for macOS

> A simple, safe, and visual bash script that completely clears the [Stremio](https://www.stremio.com) cache on macOS, freeing up disk space with a nice progress display and final summary. Perfect for users who notice Stremio taking up several gigabytes of cache over time.
> 
> **Project / Repo includes:**   
> - **DEFAULT:** CLEAR-STREMIO-CACHE.command/sh - Bash script that completely clears the Stremio cache on macOS
> - **OPTIONAL:** CLEAR-STREMIO-CACHE-WITH-FIREWORKS.command/sh - Bash script that completely clears the Stremio cache on macOS with the [Addyosmani/Firew0rks package](https://github.com/addyosmani/firew0rks) bundled [locally *(for offline support)*](firew0rks) to animate fireworks text art in the terminal when the script completes successfully.
> - Test coverage with [BATS-CORE](https://github.com/bats-core/bats-core):
>   -  [CLEAR-STREMIO-CACHE](tests/test-clear-cache.bats) tests
>   -  [CLEAR-STREMIO-CACHE-WITH-FIREWORKS](tests/test-clear-cache-with-fireworks.bats) tests
> - GitHub Actions for CI/CD:
>   - [Test Clear Cache](https://github.com/badj/CACHE-CLEANER/actions/workflows/test-clear-cache.yml)
>     - [![Test CLEAR-STREMIO-CACHE in Docker](https://github.com/badj/CACHE-CLEANER/actions/workflows/test-clear-cache.yml/badge.svg)](https://github.com/badj/CACHE-CLEANER/actions/workflows/test-clear-cache.yml)
>   - [Test Clear Cache With Fireworks](https://github.com/badj/CACHE-CLEANER/actions/workflows/test-clear-cache-with-fireworks.yml)
>     - [![Test CLEAR-STREMIO-CACHE-WITH-FIREWORKS in Docker](https://github.com/badj/CACHE-CLEANER/actions/workflows/test-clear-cache-with-fireworks.yml/badge.svg)](https://github.com/badj/CACHE-CLEANER/actions/workflows/test-clear-cache-with-fireworks.yml)
---

## Table of contents

- [Features](#features)
  - [Intended Use](#intended-use)
  - [Requirements](#requirements)
- [How to use](#how-to-use)
  - [Option 1: Easy Double-Click](#option-1-easy-double-click)
  - [Option 2: Run from Terminal](#option-2-run-from-terminal)
- [Tests](#tests)
  - [Run tests locally](#run-tests-locally)
    - [Expected output - standard run](#expected-output---standard-run) 
    - [Expected output - run with options](#expected-output---run-with-options)
    - [INFO: BATS Options/Usage/Manual](#info-bats-optionsusagemanual)
  - [CICD Integration](#cicd-integration)
- [Open issues (to be addressed in the next release)](#open-issues-to-be-addressed-in-the-next-release)

---

## Features

- **Safe**: Includes safety checks to prevent accidental deletion of important folders
- **Visual**: Shows what’s being deleted, with sizes
- **Informative**: Displays cache size before and after, plus total disk space info
- **User-friendly**: Clear-colored emojis and easy-to-read output
- **Auto-close**: Automatically closes the Terminal window when finished (macOS Terminal & iTerm2)
- **One-click ready**: Designed to be saved as a `.command` file (double-click to run)


[_⇡ Return to the Table of Contents_](#table-of-contents)


### Intended Use

* The ["CLEAR-STREMIO-CACHE.command"](CLEAR-STREMIO-CACHE.command) script targets: `/Library/Application Support/stremio-server/stremio-cache/`
  * Deletes all contents inside the cache folder (does not delete the folder itself).
* Shows you exactly what files/folders are being removed.
  * Reports how much space was freed.
  * Shows your overall macOS disk usage.


[_⇡ Return to the Table of Contents_](#table-of-contents)


### Requirements

- macOS
- Stremio installed (Desktop version that uses the local server/cache)


[_⇡ Return to the Table of Contents_](#table-of-contents)


---

## How to Use

### Option 1: Easy Double-Click

1. Download the script as `CLEAR-STREMIO-CACHE.command` or `CLEAR-STREMIO-CACHE-WITH-FIREWORKS.command`
2. (Optional but recommended) Move it to your Desktop or Applications folder
3. Open a terminal and navigate to the location of the script and make it executable

**CLEAR-STREMIO-CACHE.command/sh**

```bash
chmod +x CLEAR-STREMIO-CACHE.command
```

OR

```bash
chmod +x CLEAR-STREMIO-CACHE.sh
```

**CLEAR-STREMIO-CACHE-WITH-FIREWORKS.command/sh**

```bash
chmod +x CLEAR-STREMIO-CACHE-WITH-FIREWORKS.command
```

OR

```bash
chmod +x CLEAR-STREMIO-CACHE-WITH-FIREWORKS.sh
```

4. Double-click the file → Terminal will open and clean the cache automatically
5. Press any key when finished to close the window


[_⇡ Return to the Table of Contents_](#table-of-contents)


### Option 2: Run from Terminal

**CLEAR-STREMIO-CACHE.command/sh**

```bash
chmod +x CLEAR-STREMIO-CACHE.command
./CLEAR-STREMIO-CACHE.command
```

```bash
chmod +x CLEAR-STREMIO-CACHE.sh
./CLEAR-STREMIO-CACHE.sh
```

**CLEAR-STREMIO-CACHE-WITH-FIREWORKS.command/sh**

```bash
chmod +x CLEAR-STREMIO-CACHE-WITH-FIREWORKS.command
./CLEAR-STREMIO-CACHE-WITH-FIREWORKS.command
```

```bash
chmod +x CLEAR-STREMIO-CACHE-WITH-FIREWORKS.sh
./CLEAR-STREMIO-CACHE.sh
```

### Expected output sample - CLEAR-STREMIO-CACHE.command/sh

```terminaloutput
Last login: Mon Mar 23 14:51:56 on ttys005
testsuser:~ % /Users/testsuser/Desktop/CLEAR-STREMIO-CACHE.command ; exit;
TARGET DIRECTORY: /Users/testsuser/Library/Application Support/stremio-server/stremio-cache

CONTENTS OF STREMIO CACHE FOLDER:
total 0
drwxr-xr-x  3 testsuser  staff    96B 23 Mar 23:00 Test folder 1
drwxr-xr-x  3 testsuser  staff    96B 23 Mar 23:01 Test folder 2

CURRENT CACHE SIZE: 1 MB

→ 🚀 DELETING CONTENTS OF: /Users/testsuser/Library/Application Support/stremio-server/stremio-cache
→ 🚨 REMOVAL IN PROGRESS...
→ 🧚 FILES/FOLDERS BEING DELETED:
  DELETING:  16K	/Users/testsuser/Library/Application Support/stremio-server/stremio-cache/.DS_Store
  DELETING: 4.0K	/Users/testsuser/Library/Application Support/stremio-server/stremio-cache/Test folder 1
  DELETING: 4.0K	/Users/testsuser/Library/Application Support/stremio-server/stremio-cache/Test folder 1/test-file1.txt
  DELETING: 4.0K	/Users/testsuser/Library/Application Support/stremio-server/stremio-cache/Test folder 2
  DELETING: 4.0K	/Users/testsuser/Library/Application Support/stremio-server/stremio-cache/Test folder 2/test-file2.txt

==========================================
→ ✅ STREMIO CACHE CLEANUP COMPLETE
→ 🗑  DELETED: 1 MB
→ ✨ REMAINING CACHE SIZE AFTER CLEANUP: 0 MB
→ 🍿 FOLDER: /Users/testsuser/Library/Application Support/stremio-server/stremio-cache
==========================================
OVERALL DISK SPACE ON YOUR MAC (MAIN DRIVE):

  TOTAL DISK SIZE:  460Gi
  USED:             12Gi
  FREE (REMAINING): 63Gi
  USED PERCENTAGE:  16%

YOU NOW HAVE APPROXIMATELY 63Gi OF FREE SPACE REMAINING ON YOUR MAIN DRIVE.
==========================================
                                 
→ THANKS FOR USING CACHE-CLEANER 🤙 !                                        
                                                                             
→ 🏁 PRESS ANY KEY TO CLOSE THE TERMINAL WINDOW...                           
                                                                                                                                
```

### Expected output sample - CLEAR-STREMIO-CACHE-WITH-FIREWORKS.command/sh

```terminaloutput
Last login: Mon Mar 23 14:51:56 on ttys005
testsuser:~ % /Users/testsuser/Desktop/CLEAR-STREMIO-CACHE-WITH-FIREWORKS.command ; exit;
TARGET DIRECTORY: /Users/testsuser/Library/Application Support/stremio-server/stremio-cache

CONTENTS OF STREMIO CACHE FOLDER:
total 0
drwxr-xr-x  3 testsuser  staff    96B 23 Mar 23:00 Test folder 1
drwxr-xr-x  3 testsuser  staff    96B 23 Mar 23:01 Test folder 2

CURRENT CACHE SIZE: 1 MB

→ 🚀 DELETING CONTENTS OF: /Users/testsuser/Library/Application Support/stremio-server/stremio-cache
→ 🚨 REMOVAL IN PROGRESS...
→ 🧚 FILES/FOLDERS BEING DELETED:
  DELETING:  16K	/Users/testsuser/Library/Application Support/stremio-server/stremio-cache/.DS_Store
  DELETING: 4.0K	/Users/testsuser/Library/Application Support/stremio-server/stremio-cache/Test folder 1
  DELETING: 4.0K	/Users/testsuser/Library/Application Support/stremio-server/stremio-cache/Test folder 1/test-file1.txt
  DELETING: 4.0K	/Users/testsuser/Library/Application Support/stremio-server/stremio-cache/Test folder 2
  DELETING: 4.0K	/Users/testsuser/Library/Application Support/stremio-server/stremio-cache/Test folder 2/test-file2.txt

==========================================
→ ✅ STREMIO CACHE CLEANUP COMPLETE
→ 🗑  DELETED: 1 MB
→ ✨ REMAINING CACHE SIZE AFTER CLEANUP: 0 MB
→ 🍿 FOLDER: /Users/testsuser/Library/Application Support/stremio-server/stremio-cache
==========================================
OVERALL DISK SPACE ON YOUR MAC (MAIN DRIVE):

  TOTAL DISK SIZE:  460Gi
  USED:             12Gi
  FREE (REMAINING): 63Gi
  USED PERCENTAGE:  16%

YOU NOW HAVE APPROXIMATELY 63Gi OF FREE SPACE REMAINING ON YOUR MAIN DRIVE.
==========================================

→  🎆  ENJOY SOME FIREWORKS FOR A SUCCESSFUL CLEANUP  🎆  !                                                                             

            +*_          -                        .           .             
              `^,         ;  __^    _=             '        , `)             
                '- ^,  ^  ' {)' =^_^               `       `,  - `,`;        
      ^'^+_      `` '  -  ` ;)x[ '   _=*      ;`       . .  '     ( '        
    __.  ]7^+,`', `'xx.   Y!-{^,  .+' .       '   ..   ; '      . '    ``.   
       `^-'^^_^^-- `'^!' `!.!'. -'^''` `      .`  ) `` ! '       ! `     )   
     ^^'`'`; .` ;`'.x=;'`-)*'__;.`_+^^*       ;`.`^ ) -`.   .    ^  ,    -  `
   ^^''`]=+__,;`. -.-'!'^!;;;;{^*4)*+=+__.''''/+; ` - ) ;   ' `- `;`-        
        ;.    `x*^!;x[(;`;-';^-..'.'`.'_;'+..=[_!     - '   !   , )`.;       
 _+''/^```____,,`..*^7;;xz1'..';;)(){=_/       ^-          .`.. (`'`-)`.   `.
    ==^]y^';'-'_+!';-][)@7{\;^+;/)^-^172+ ....``.`````-`.`.;  ;.'`. `].`-. ``
 =*7!' ' `_+-z^' '-!-5y!\;1z1;;7\;. ''_7%..`''+_' ;.;`;.;--)`.);  `, 1 `);  `
7''`   .=^' `. ;,;)!;$7/)(;]]$)_`;{_` -^-`!)`..;` !;)-!;);;{`-;)   (.^  )'`. 
    ..'^ _`'. +^_[{!'^51]$(7Z7{;x'`*,-'.''![,` )  !({;[)^)[(-;'--  ^,  `-  ' 
  _^` .`' .-'x'_91^';'Z{77[)]1.'{[,.;)_ !))'''='.``!^;]{!]^(-('-`, `!   `,  `
  ` ='`  _'``.=^yy`.(;){*Y--7/z.'^+;(;^+ _^.  /`;`-'';7/'^`!;[`;`(  `    `,  
  .*   .y `. Z'=^` ;(;).';` Y2*;._^[^)_  1_-  --!`;`.;^! -;'[[`--[    `   [  
      ``  +`+'+y``;-),]'')  ^^,'';.Y[ \=`' * .--!-;`-! ;`;!-Z*`;\- `.  '  ^  
     ```_'-x'_^ `.!)) Z';{, ` ^  !; '$,Y$   ^;;-!';`-'`(`)!)'!`(^!  `.  ;  ` 
     ``_` 4'.7   ) [+`;`+''  . ` _\  ^2 `  .`/'!!`!--``)`^-)'' ! [,  ,` \    
     `x` .' y`   $)7' `_+,`` _ ` _`' )',   ; *'[! ';)``-`  ; ' ' ^!  ' `*    
     '` .!``^` ` '/7`  +{, `    .   .^ ^   ' ;`1' `!]- `; `````   ^  ' `.    
       `  `  '    -[ _`]'     (  .  ;     `  ' ^`  !/; ;) ````` . '     !    
     ` `         =]! =`7'     x  )             '   `!; !- -`- - - -`    )    
     `    `    ` *`' ^`*[     -               `     `- !' ;;; ;,; '` `  ';   
          `       -`    '`                        . .- ,  ;,; ''' . ` .      
                         `                   ;    -  ;    ''),-'' ' - '   ,  
                         `                   .    `  '      )'      ' -   '  
                                             '     ; '      '         '      
 `                                                 .                 ,       
 `                                                 '  _              '       
 `                                                    ' `                    
                                                                             
                                 
→ THANKS FOR USING CACHE-CLEANER 🤙 !                                        
                                                                             
→ 🏁 PRESS ANY KEY TO CLOSE THE TERMINAL WINDOW...                           
                                                                                                                                
```


[_⇡ Return to the Table of Contents_](#table-of-contents)


---

## Tests

> * A lightweight [test suite: test-clear-cache.bats](tests/test-clear-cache.bats) is integrated that use [BATS-CORE (Bash Automated Testing System)](https://github.com/bats-core/bats-core) to test the [CLEAR-STREMIO-CACHE.sh](CLEAR-STREMIO-CACHE.sh) shell script in CI / [with GitHub Action: `test-clear-cache`](.github/workflows/test-clear-cache.yml) in Docker to simulate the filesystem layout.
> * It mocks dangerous parts (rm -rf) and checks the exit code, output parsing, safety guards, size calculation logic.

### Run tests locally

- Run the following command from the root of the project in a terminal

```bash
   bats --tap tests/test-clear-cache.bats
````

- OR run with options to trace and provide timing details during test execution

```bash
   bats --tap --trace --timing tests/test-clear-cache.bats
````

> ⚠️ **NOTE:** 
> - The tests run locally will pause output from `Test 3 - safety check - refuses to delete $HOME (critical path protection)` due to the wait time for the fireworks terminal text animations to compete in the background.
> - HIT any keyboard KEY to continue the test run and cycle through the remaining tests to complete the 12 tests in the test suite.

### Expected output - standard run

> Successful / completed test suite local run with 12 tests passing

```terminaloutput
  CACHE-CLEANER (main) % bats --tap tests/test-clear-cache.bats
  1..12
  ok 1 Test 1 - safety check - refuses to delete /
  mock rm -f /var/folders/38/v1629dtx735bjmzyy8sx8w0r0000gn/T/bats-run-ZPkhNI/test/1.out
  ok 2 Test 2 - safety check - refuses to delete / (critical path protection)
  mock rm -f /var/folders/38/v1629dtx735bjmzyy8sx8w0r0000gn/T/bats-run-ZPkhNI/test/2.out
  ok 3 Test 3 - safety check - refuses to delete $HOME (critical path protection)
  mock rm -f /var/folders/38/v1629dtx735bjmzyy8sx8w0r0000gn/T/bats-run-ZPkhNI/test/3.out
  ok 4 Test 4 - shows size before (mocked du)
  mock rm -f /var/folders/38/v1629dtx735bjmzyy8sx8w0r0000gn/T/bats-run-ZPkhNI/test/4.out
  ok 5 Test 5 - mock deletion - counts deleted MB correctly
  mock rm -f /var/folders/38/v1629dtx735bjmzyy8sx8w0r0000gn/T/bats-run-ZPkhNI/test/5.out
  ok 6 Test 6 - does not crash when folder is already empty
  mock rm -f /var/folders/38/v1629dtx735bjmzyy8sx8w0r0000gn/T/bats-run-ZPkhNI/test/6.out
  ok 7 Test 7 - df parsing - formats header and values correctly (mocked df)
  mock rm -f /var/folders/38/v1629dtx735bjmzyy8sx8w0r0000gn/T/bats-run-ZPkhNI/test/7.out
  ok 8 Test 8 - du -sm - empty folder reports 0 MB before and after
  mock rm -f /var/folders/38/v1629dtx735bjmzyy8sx8w0r0000gn/T/bats-run-ZPkhNI/test/8.out
  ok 9 Test 9 - du -sm - very large cache size (multi-gigabyte reported as MB)
  mock rm -f /var/folders/38/v1629dtx735bjmzyy8sx8w0r0000gn/T/bats-run-ZPkhNI/test/9.out
  ok 10 Test 10 - du -sm - very small non-zero size (fractional rounding)
  mock rm -f /var/folders/38/v1629dtx735bjmzyy8sx8w0r0000gn/T/bats-run-ZPkhNI/test/10.out
  ok 11 Test 11 - du -sm — du fails or returns garbage → script still exits cleanly
  mock rm -f /var/folders/38/v1629dtx735bjmzyy8sx8w0r0000gn/T/bats-run-ZPkhNI/test/11.out
  ok 12 Test 12 - size calculation handles negative result (defensive — shouldn't happen)
  mock rm -f /var/folders/38/v1629dtx735bjmzyy8sx8w0r0000gn/T/bats-run-ZPkhNI/test/12.out
```

[_⇡ Return to the Table of Contents_](#table-of-contents)

### Expected output - run with options

> Expected output for a successful / completed test suite local run with options `--trace --timing` for 12 tests passing

```terminaloutput
CACHE-CLEANER (main) % bats --tap --trace --timing tests/test-clear-cache.bats
1..12
$ [test-clear-cache.bats, line 40]
$ rm -rf "$TARGET" "$HOME" "$BATS_TMPDIR/bin"
ok 1 Test 1 - safety check - refuses to delete / in 107ms
mock rm -f /var/folders/38/v1629dtx735bjmzyy8sx8w0r0000gn/T/bats-run-GaSiPs/test/1.out
$ [test-clear-cache.bats, line 40]
$ rm -rf "$TARGET" "$HOME" "$BATS_TMPDIR/bin"
ok 2 Test 2 - safety check - refuses to delete / (critical path protection) in 56ms
mock rm -f /var/folders/38/v1629dtx735bjmzyy8sx8w0r0000gn/T/bats-run-GaSiPs/test/2.out
$ [test-clear-cache.bats, line 40]
$ rm -rf "$TARGET" "$HOME" "$BATS_TMPDIR/bin"
ok 3 Test 3 - safety check - refuses to delete $HOME (critical path protection) in 59ms
mock rm -f /var/folders/38/v1629dtx735bjmzyy8sx8w0r0000gn/T/bats-run-GaSiPs/test/3.out
$ [test-clear-cache.bats, line 39]
$ teardown >> "$BATS_OUT" 2>&1
$ rm -rf "$TARGET" "$HOME" "$BATS_TMPDIR/bin"
ok 4 Test 4 - shows size before (mocked du) in 7533ms
mock rm -f /var/folders/38/v1629dtx735bjmzyy8sx8w0r0000gn/T/bats-run-GaSiPs/test/4.out
$ [test-clear-cache.bats, line 40]
$ rm -rf "$TARGET" "$HOME" "$BATS_TMPDIR/bin"
ok 5 Test 5 - mock deletion - counts deleted MB correctly in 8833ms
mock rm -f /var/folders/38/v1629dtx735bjmzyy8sx8w0r0000gn/T/bats-run-GaSiPs/test/5.out
$ [test-clear-cache.bats, line 39]
$ teardown >> "$BATS_OUT" 2>&1
$ rm -rf "$TARGET" "$HOME" "$BATS_TMPDIR/bin"
ok 6 Test 6 - does not crash when folder is already empty in 4728ms
mock rm -f /var/folders/38/v1629dtx735bjmzyy8sx8w0r0000gn/T/bats-run-GaSiPs/test/6.out
$ [test-clear-cache.bats, line 39]
$ teardown >> "$BATS_OUT" 2>&1
$ rm -rf "$TARGET" "$HOME" "$BATS_TMPDIR/bin"
ok 7 Test 7 - df parsing - formats header and values correctly (mocked df) in 1107ms
mock rm -f /var/folders/38/v1629dtx735bjmzyy8sx8w0r0000gn/T/bats-run-GaSiPs/test/7.out
$ [test-clear-cache.bats, line 39]
$ teardown >> "$BATS_OUT" 2>&1
$ rm -rf "$TARGET" "$HOME" "$BATS_TMPDIR/bin"
ok 8 Test 8 - du -sm - empty folder reports 0 MB before and after in 1277ms
mock rm -f /var/folders/38/v1629dtx735bjmzyy8sx8w0r0000gn/T/bats-run-GaSiPs/test/8.out
$ [test-clear-cache.bats, line 40]
$ rm -rf "$TARGET" "$HOME" "$BATS_TMPDIR/bin"
ok 9 Test 9 - du -sm - very large cache size (multi-gigabyte reported as MB) in 965ms
mock rm -f /var/folders/38/v1629dtx735bjmzyy8sx8w0r0000gn/T/bats-run-GaSiPs/test/9.out
$ [test-clear-cache.bats, line 40]
$ rm -rf "$TARGET" "$HOME" "$BATS_TMPDIR/bin"
ok 10 Test 10 - du -sm - very small non-zero size (fractional rounding) in 956ms
mock rm -f /var/folders/38/v1629dtx735bjmzyy8sx8w0r0000gn/T/bats-run-GaSiPs/test/10.out
$ [test-clear-cache.bats, line 39]
$ teardown >> "$BATS_OUT" 2>&1
$ rm -rf "$TARGET" "$HOME" "$BATS_TMPDIR/bin"
ok 11 Test 11 - du -sm — du fails or returns garbage → script still exits cleanly in 917ms
mock rm -f /var/folders/38/v1629dtx735bjmzyy8sx8w0r0000gn/T/bats-run-GaSiPs/test/11.out
$ [test-clear-cache.bats, line 40]
$ rm -rf "$TARGET" "$HOME" "$BATS_TMPDIR/bin"
ok 12 Test 12 - size calculation handles negative result (defensive — shouldn't happen) in 974ms
mock rm -f /var/folders/38/v1629dtx735bjmzyy8sx8w0r0000gn/T/bats-run-GaSiPs/test/12.out
```

[_⇡ Return to the Table of Contents_](#table-of-contents)

### INFO: Bats Options/Usage/Manual:

```terminaloutput
% bats -h
Bats 1.13.0
Usage: bats [OPTIONS] <tests>
       bats [-h | -v]

  <tests> is the path to a Bats test file, or the path to a directory
  containing Bats test files (ending with ".bats")

  --abort                   Stop execution of suite on first failed test
  -c, --count               Count test cases without running any tests
  --code-quote-style <style>
                            A two character string of code quote delimiters
                            or 'custom' which requires setting $BATS_BEGIN_CODE_QUOTE and
                            $BATS_END_CODE_QUOTE. Can also be set via $BATS_CODE_QUOTE_STYLE
  --line-reference-format   Controls how file/line references e.g. in stack traces are printed:
                              - comma_line (default): a.bats, line 1
                              - colon:  a.bats:1
                              - uri: file:///tests/a.bats:1
                              - custom: provide your own via defining bats_format_file_line_reference_custom
                                        with parameters <filename> <line>, store via `printf -v "$output"`
  -f, --filter <regex>      Only run tests that match the regular expression
  --negative-filter <regex> Only run tests that do not match the regular expression
  --filter-status <status>  Only run tests with the given status in the last completed (no CTRL+C/SIGINT) run.
                            Valid <status> values are:
                              failed - runs tests that failed or were not present in the last run
                              missed - runs tests that were not present in the last run
  --filter-tags <comma-separated-tag-list>
                            Only run tests that match all the tags in the list (&&).
                            You can negate a tag via prepending '!'.
                            Specifying this flag multiple times allows for logical or (||):
                            `--filter-tags A,B --filter-tags A,!C` matches tags (A && B) || (A && !C)
  -F, --formatter <type>    Switch between formatters: pretty (default),
                              tap (default w/o term), tap13, junit, /<absolute path to formatter>
  --gather-test-outputs-in <directory>
                            Gather the output of failing *and* passing tests
                            as files in directory (if existing, must be empty)
  -h, --help                Display this help message
  -j, --jobs <jobs>         Number of parallel jobs (requires GNU parallel or shenwei356/rush)
  --parallel-binary-name    Name of parallel binary
  --no-tempdir-cleanup      Preserve test output temporary directory
  --no-parallelize-across-files
                            Serialize test file execution instead of running
                            them in parallel (requires --jobs >1)
  --no-parallelize-within-files
                            Serialize test execution within files instead of
                            running them in parallel (requires --jobs >1)
  --report-formatter <type> Switch between reporters (same options as --formatter)
  -o, --output <dir>        Directory to write report files (must exist)
  -p, --pretty              Shorthand for "--formatter pretty"
  --print-output-on-failure Automatically print the value of `$output` on failed tests
  -r, --recursive           Include tests in subdirectories
  --show-output-of-passing-tests
                            Print output of passing tests
  -t, --tap                 Shorthand for "--formatter tap"
  -T, --timing              Add timing information to tests
  -x, --trace               Print test commands as they are executed (like `set -x`)
  --verbose-run             Make `run` print `$output` by default
  -v, --version             Display the version number

  For more information, see https://github.com/bats-core/bats-core
```

[_⇡ Return to the Table of Contents_](#table-of-contents)


## CICD Integration

**GitHub Actions/Workflows:**

- GitHub Action/Workflow implemented to [test the CLEAR-STREMIO-CACHE.command](https://github.com/badj/CACHE-CLEANER/actions/workflows/test-clear-cache.yml) on every commit/push/pull request to main and daily scheduled runs.
  - [![Test CLEAR-STREMIO-CACHE in Docker](https://github.com/badj/CACHE-CLEANER/actions/workflows/test-clear-cache.yml/badge.svg)](https://github.com/badj/CACHE-CLEANER/actions/workflows/test-clear-cache.yml)
- GitHub Action/Workflow implemented to [test the CLEAR-STREMIO-CACHE-WITH-FIREWORKS.command](https://github.com/badj/CACHE-CLEANER/actions/workflows/test-clear-cache-with-fireworks.yml) on every commit/push/pull request to main and daily scheduled runs.
  - [![Test CLEAR-STREMIO-CACHE-WITH-FIREWORKS in Docker](https://github.com/badj/CACHE-CLEANER/actions/workflows/test-clear-cache-with-fireworks.yml/badge.svg)](https://github.com/badj/CACHE-CLEANER/actions/workflows/test-clear-cache-with-fireworks.yml)


[_⇡ Return to the Table of Contents_](#table-of-contents)


---

## Open issues to be addressed in the next release

* STATUS: ⚠️ OPEN/WIP/Being investigated:

1. [Fix this disabled test (Test 4 - exits with error when target folder does not exist) - failing in CI but passing locally on macOS](https://github.com/badj/CACHE-CLEANER/issues/1)


[_⇡ Return to the Table of Contents_](#table-of-contents)

---
