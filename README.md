# Stremio Cache Cleaner for macOS

> A simple, safe, and visual bash script that completely clears the [Stremio](https://www.stremio.com) cache on macOS, freeing up disk space with a nice progress display and final summary. Perfect for users who notice Stremio taking up several gigabytes of cache over time.
> 
> Project / Repo includes test coverage with [BATS-CORE](https://github.com/bats-core/bats-core) and [GitHub Actions](https://github.com/badj/CACHE-CLEANER/actions/workflows/test-clear-cache.yml) for CI/CD.
 

---

## Table of contents

- [Features](#features)
  - [Intended Use](#intended-use)
  - [Requirements](#requirements)
- [How to use](#how-to-use)
  - [Option 1: Easy Double-Click](#option-1-easy-double-click)
  - [Option 2: Run from Terminal](#option-2-run-from-terminal)
- [Tests](#tests)
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

1. Download the script as `CLEAR-STREMIO-CACHE.command`
2. (Optional but recommended) Move it to your Desktop or Applications folder
3. Open a terminal and navigate to the location of the script and make it executable

```bash
chmod +x clear-stremio-cache.sh
```

4. Double-click the file → Terminal will open and clean the cache automatically
5. Press any key when finished to close the window


[_⇡ Return to the Table of Contents_](#table-of-contents)


### Option 2: Run from Terminal

```bash
chmod +x CLEAR-STREMIO-CACHE.command
./CLEAR-STREMIO-CACHE.command
```

### Expected output sample:

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

→ 🏁 PRESS ANY KEY TO CLOSE THE TERMINAL WINDOW...

```


[_⇡ Return to the Table of Contents_](#table-of-contents)


---

## Tests

> * A lightweight [test suite: test-clear-cache.bats](tests/test-clear-cache.bats) is integrated that use [BATS-CORE (Bash Automated Testing System)](https://github.com/bats-core/bats-core) to test the [CLEAR-STREMIO-CACHE.sh](CLEAR-STREMIO-CACHE.sh) shell script in CI / [with GitHub Action: `test-clear-cache`](.github/workflows/test-clear-cache.yml) in Docker to simulate the filesystem layout.
> * It mocks dangerous parts (rm -rf) and checks the exit code, output parsing, safety guards, size calculation logic.

**To run the test locally**

1. Run the following command from the root of the project in a terminal

```bash
   bats --tap tests/test-clear-cache.bats
````

2. ⚠️NOTE: The test will pause output from `Test 3 - safety check - refuses to delete $HOME (critical path protection)` - HIT any keyboard KEY to continue the test run and cycle through the remaining tests to complete the 12 tests in the test suite.

**Expected output for a successful / completed test suite run with 12 tests passing**

```bash
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


## CICD Integration

**GitHub Actions/Workflow:**

- GitHub Action/Workflow implemented to [test the CLEAR-STREMIO-CACHE.command](https://github.com/badj/CACHE-CLEANER/actions/workflows/test-clear-cache.yml) on every commit/push/pull request to main and daily scheduled runs.
- [![Test CLEAR-STREMIO-CACHE in Docker](https://github.com/badj/CACHE-CLEANER/actions/workflows/test-clear-cache.yml/badge.svg)](https://github.com/badj/CACHE-CLEANER/actions/workflows/test-clear-cache.yml)


[_⇡ Return to the Table of Contents_](#table-of-contents)


---

## Open issues to be addressed in the next release

* STATUS: ⚠️ OPEN/WIP/Being investigated:

1. [Fix this disabled test (Test 4 - exits with error when target folder does not exist) - failing in CI but passing locally on macOS](https://github.com/badj/CACHE-CLEANER/issues/1)


[_⇡ Return to the Table of Contents_](#table-of-contents)

---
