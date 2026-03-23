#!/usr/bin/env bats

load '../test_helper/bats-support/load'
load '../test_helper/bats-assert/load'

# Directory containing this test file
TEST_DIR="$(cd "$(dirname "$BATS_TEST_FILENAME")" >/dev/null 2>&1 && pwd)"
# Repo root is one level up from tests/
REPO_ROOT="$TEST_DIR/.."
PATH="$REPO_ROOT:$PATH"
SCRIPT="$REPO_ROOT/CLEAR-STREMIO-CACHE.sh"

setup() {
  export TARGET="$BATS_TMPDIR/stremio-cache-test"
  mkdir -p "$TARGET"

  # Create fake cache content (already good)
  mkdir -p "$TARGET/subfolder"
  echo "fake data" > "$TARGET/file1.bin"
  echo "more data" > "$TARGET/file2.mp4"
  dd if=/dev/zero of="$TARGET/bigfile" bs=1M count=6 2>/dev/null || true

  # Fake HOME
  export HOME="$BATS_TMPDIR/fakehome"
  mkdir -p "$HOME"

  # Crucial: create the structure the script expects
  mkdir -p "$HOME/Library/Application Support/stremio-server/stremio-cache"

  # Make bin dir for mocks (already there, but ensure)
  mkdir -p "$BATS_TMPDIR/bin"
  export PATH="$BATS_TMPDIR/bin:$PATH"
  hash -r   # ← invalidate bash path cache
}

teardown() {
  rm -rf "$TARGET" "$HOME" "$BATS_TMPDIR/bin"
}

# ──────────────────────────────────────── TESTS ────────────────────────────────────────

@test "Test 1 - safety check - refuses to delete /" {
  # Create a temporary version that doesn't hardcode TARGET
  local temp_script="$BATS_TMPDIR/temp-clear-cache.sh"
  sed 's/^TARGET=.*$/TARGET="${TARGET:-~\/Library\/Application Support\/stremio-server\/stremio-cache}"/' "$SCRIPT" > "$temp_script"
  chmod +x "$temp_script"

  run bash -c "TARGET=/ bash \"$temp_script\""

  assert_failure
  assert_output --partial "Refusing to operate on a critical directory"

  rm -f "$temp_script"
}

@test "Test 2 - safety check - refuses to delete / (critical path protection)" {
  local temp_script="$BATS_TMPDIR/temp-clear-cache-2.sh"

  # Same sed as in Test 1 – make TARGET overridable
  sed 's/^TARGET=.*$/TARGET="${TARGET:-~\/Library\/Application Support\/stremio-server\/stremio-cache}"/' "$SCRIPT" > "$temp_script"
  chmod +x "$temp_script"

  run bash -c "TARGET=/ bash \"$temp_script\""

  assert_failure
  assert_output --partial "Refusing to operate on a critical directory"

  rm -f "$temp_script"
}

@test "Test 3 - safety check - refuses to delete \$HOME (critical path protection)" {
  local temp_script="$BATS_TMPDIR/temp-clear-cache-home.sh"

  # Make TARGET overridable (same sed as in previous tests)
  sed 's/^TARGET=.*$/TARGET="${TARGET:-~\/Library\/Application Support\/stremio-server\/stremio-cache}"/' "$SCRIPT" > "$temp_script"
  chmod +x "$temp_script"

  run bash -c "TARGET=\"\$HOME\" bash \"$temp_script\""

  assert_failure
  assert_output --partial "Refusing to operate on a critical directory"

  rm -f "$temp_script"
}

@test "Test 4 - exits with error when target folder does not exist" {
  local real_target="$HOME/Library/Application Support/stremio-server/stremio-cache"

  echo "Before deletion:"
  echo "  HOME        = $HOME"
  echo "  Real target = $real_target"
  ls -la "$real_target" 2>/dev/null || echo "  (not present)"

  # ── Aggressive deletion strategy ──
  (
    cd /tmp 2>/dev/null || cd / 2>/dev/null || true

    # Remove extended attributes (macOS quirk)
    xattr -cr "$real_target" 2>/dev/null || true

    # Use find to delete contents + folder itself
    find "$real_target" -mindepth 1 -delete 2>/dev/null
    rm -rf "$real_target" 2>/dev/null
    rmdir "$real_target" 2>/dev/null   # just in case

    sync
    sleep 0.3
    rm -rf "$real_target" 2>/dev/null
  )

  # Verify
  if [[ -d "$real_target" ]]; then
    echo "ERROR: STILL EXISTS AFTER AGGRESSIVE DELETION" >&2
    ls -la "$real_target" >&2
    xattr -l "$real_target" 2>/dev/null >&2
    exit 1
  fi

  echo "Directory is gone"

  run bash "$SCRIPT"

  echo "Exit status = $status"
  echo "Output first 12 lines:"
  echo "$output" | head -n 12

  assert_failure
  assert_output --partial "Directory does not exist"
  refute_output --partial "DELETING CONTENTS OF"
}

@test "Test 5 - shows size before (mocked du)" {
  cat > "$BATS_TMPDIR/bin/du" <<'EOF'
#!/usr/bin/env bash
if [[ "$1" == "-sm" ]]; then
  echo "42	$2"
else
  /usr/bin/du "$@"
fi
EOF
  chmod +x "$BATS_TMPDIR/bin/du"

  run bash "$SCRIPT"
  assert_success
  assert_output --partial "CURRENT CACHE SIZE: 42 MB"
}

# TODO: NOTE - test disabled because it requires the confirmation prompt to be active in the script, which is currently commented out for convenience.
# To enable this test, uncomment the confirmation lines in the script and adjust the test as needed.

#@test "Test 6 - does NOT delete anything when confirmation is required (uncomment & test)" {
#  # Assumes confirmation prompt is active in the script
#  run bash -c 'echo "nope" | bash "'"$SCRIPT"'"'
#  assert_output --partial "Operation aborted"
#}

@test "Test 7 - mock deletion - counts deleted MB correctly" {
  # Mock rm — just log and succeed
  cat > "$BATS_TMPDIR/bin/rm" <<'EOF'
#!/usr/bin/env bash
echo "mock rm $*" >&2
exit 0
EOF
  chmod +x "$BATS_TMPDIR/bin/rm"

  # Mock du — use environment variable to distinguish before vs after
  cat > "$BATS_TMPDIR/bin/du" <<'EOF'
#!/usr/bin/env bash
if [[ "$1" == "-sm" ]]; then
  if [[ "$DU_PHASE" == "after" ]]; then
    echo "4	$2"
  else
    echo "42	$2"
  fi
else
  /usr/bin/du "$@"
fi
EOF
  chmod +x "$BATS_TMPDIR/bin/du"

  # Tell mock it's the "before" phase
  export DU_PHASE="before"

  run bash -c "
    # Run script normally
    bash \"$SCRIPT\"
    # After script finishes, we can check output
  "

  # The deletion happens inside the script — we set phase before deletion
  # But since we can't inject mid-script, we need to patch the script slightly

  # Better approach: patch the script to set DU_PHASE around the rm
  local temp_script="$BATS_TMPDIR/temp-du-phase.sh"
  sed -e '/→ 🚨 REMOVAL IN PROGRESS.../a\
export DU_PHASE="after"' \
      -e '/DELETING CONTENTS OF:/i\
export DU_PHASE="before"' "$SCRIPT" > "$temp_script"
  chmod +x "$temp_script"

  # Now run the patched version
  run bash "$temp_script"

  assert_success
  assert_output --partial "CURRENT CACHE SIZE: 42 MB"
  assert_output --partial "DELETED: 38 MB"
  assert_output --partial "REMAINING CACHE SIZE AFTER CLEANUP: 4 MB"

  rm -f "$temp_script"
}

@test "Test 8 - does not crash when folder is already empty" {
  rm -rf "${TARGET:?}"/*
  run bash "$SCRIPT"
  assert_success
  assert_output --partial "DELETED: 0 MB"
}

# ──────────────────────────────────────────────────────────────────────────────
#  df output parsing tests
# ──────────────────────────────────────────────────────────────────────────────

@test "Test 9 - df parsing - formats header and values correctly (mocked df)" {
  cat > "$BATS_TMPDIR/bin/df" <<'EOF'
#!/usr/bin/env bash
if [[ "$1" == "-h" && "$2" == "/" ]]; then
  echo "Filesystem      Size   Used  Avail Capacity  Mounted on"
  echo "/dev/disk1s1   494Gi  421Gi   73Gi    86%    /"
else
  command df "$@"
fi
EOF
  chmod +x "$BATS_TMPDIR/bin/df"

  run bash "$SCRIPT"
  assert_success
  assert_output --partial "TOTAL DISK SIZE:  494Gi"
  assert_output --partial "FREE (REMAINING): 73Gi"
  assert_output --partial "USED PERCENTAGE:  86%"
}

# ──────────────────────────────────────────────────────────────────────────────
#  du -sm edge case tests
# ──────────────────────────────────────────────────────────────────────────────

@test "Test 10 - du -sm - empty folder reports 0 MB before and after" {
  rm -rf "${TARGET:?}"/* "${TARGET:?}"/.[!.]*

  cat > "$BATS_TMPDIR/bin/du" <<'EOF'
#!/usr/bin/env bash
if [[ "$1" == "-sm" ]]; then
  echo "0	$2"
else
  command du "$@"
fi
EOF
  chmod +x "$BATS_TMPDIR/bin/du"

  run bash "$SCRIPT"
  assert_success
  assert_line --partial "CURRENT CACHE SIZE: 0 MB"
  assert_line --partial "DELETED: 0 MB"
}

@test "Test 11 - du -sm - very large cache size (multi-gigabyte reported as MB)" {
  local mock_du_before="$BATS_TMPDIR/bin/du_before"
  local mock_du_after="$BATS_TMPDIR/bin/du_after"

  # First du -sm call (SIZE_BEFORE): always returns 28500
  cat > "$mock_du_before" <<'EOF'
#!/usr/bin/env bash
if [[ "$1" == "-sm" ]]; then echo "28500	$2"; else /usr/bin/du "$@"; fi
EOF
  chmod +x "$mock_du_before"

  # Second du -sm call (SIZE_AFTER): always returns 1200
  cat > "$mock_du_after" <<'EOF'
#!/usr/bin/env bash
if [[ "$1" == "-sm" ]]; then echo "1200	$2"; else /usr/bin/du "$@"; fi
EOF
  chmod +x "$mock_du_after"

  # Patch script: first "du -sm" → mock_du_before, second → mock_du_after
  local patched="$BATS_TMPDIR/patched-large.sh"
  awk -v mb="$mock_du_before" -v ma="$mock_du_after" '
    !done && /du -sm/ { sub(/du -sm/, mb " -sm"); done=1; print; next }
    { gsub(/du -sm/, ma " -sm"); print }
  ' "$SCRIPT" > "$patched"
  chmod +x "$patched"

  run bash "$patched"

  assert_success
  assert_line --partial "CURRENT CACHE SIZE: 28500 MB"
  assert_line --partial "DELETED: 27300 MB"
  assert_line --partial "REMAINING CACHE SIZE AFTER CLEANUP: 1200 MB"

  rm -f "$patched"
}

@test "Test 12 - du -sm - very small non-zero size (fractional rounding)" {
  local mock_du_before="$BATS_TMPDIR/bin/du_before"
  local mock_du_after="$BATS_TMPDIR/bin/du_after"

  # First du -sm call (SIZE_BEFORE): always returns 1
  cat > "$mock_du_before" <<'EOF'
#!/usr/bin/env bash
if [[ "$1" == "-sm" ]]; then echo "1	$2"; else /usr/bin/du "$@"; fi
EOF
  chmod +x "$mock_du_before"

  # Second du -sm call (SIZE_AFTER): always returns 0
  cat > "$mock_du_after" <<'EOF'
#!/usr/bin/env bash
if [[ "$1" == "-sm" ]]; then echo "0	$2"; else /usr/bin/du "$@"; fi
EOF
  chmod +x "$mock_du_after"

  echo "hello" > "$TARGET/smallfile.txt"

  # Patch script: first "du -sm" → mock_du_before, second → mock_du_after
  local patched="$BATS_TMPDIR/patched-small.sh"
  awk -v mb="$mock_du_before" -v ma="$mock_du_after" '
    !done && /du -sm/ { sub(/du -sm/, mb " -sm"); done=1; print; next }
    { gsub(/du -sm/, ma " -sm"); print }
  ' "$SCRIPT" > "$patched"
  chmod +x "$patched"

  run bash "$patched"

  assert_success
  assert_line --partial "CURRENT CACHE SIZE: 1 MB"
  assert_line --partial "DELETED: 1 MB"
  assert_line --partial "REMAINING CACHE SIZE AFTER CLEANUP: 0 MB"

  rm -f "$patched"
}

@test "Test 13 - du -sm — du fails or returns garbage → script still exits cleanly" {
  mkdir -p "$BATS_TMPDIR/bin"
  cat > "$BATS_TMPDIR/bin/du" <<'EOF'
#!/usr/bin/env bash
echo "error: disk full or permission denied" >&2
exit 5
EOF
  chmod +x "$BATS_TMPDIR/bin/du"
#  export PATH="$BATS_TMPDIR/bin:$PATH"

  run bash "$SCRIPT"

  # We want the script to continue (graceful handling) even if size is wrong
  assert_success
  # Optional: check that size shows as empty or unknown
  assert_line --partial "CURRENT CACHE SIZE: "   # might be empty or 0
  # The deletion should still be attempted (real script behavior)
  assert_line --partial "DELETING CONTENTS OF:"
}

@test "Test 14 - size calculation handles negative result (defensive — shouldn't happen)" {
  local mock_du_before="$BATS_TMPDIR/bin/du_before"
  local mock_du_after="$BATS_TMPDIR/bin/du_after"

  # First du -sm call (SIZE_BEFORE): always returns 10
  cat > "$mock_du_before" <<'EOF'
#!/usr/bin/env bash
if [[ "$1" == "-sm" ]]; then echo "10	$2"; else /usr/bin/du "$@"; fi
EOF
  chmod +x "$mock_du_before"

  # Second du -sm call (SIZE_AFTER): always returns 40 (larger than before → negative DELETED)
  cat > "$mock_du_after" <<'EOF'
#!/usr/bin/env bash
if [[ "$1" == "-sm" ]]; then echo "40	$2"; else /usr/bin/du "$@"; fi
EOF
  chmod +x "$mock_du_after"

  # Patch script: first "du -sm" → mock_du_before, second → mock_du_after
  local patched="$BATS_TMPDIR/patched-negative.sh"
  awk -v mb="$mock_du_before" -v ma="$mock_du_after" '
    !done && /du -sm/ { sub(/du -sm/, mb " -sm"); done=1; print; next }
    { gsub(/du -sm/, ma " -sm"); print }
  ' "$SCRIPT" > "$patched"
  chmod +x "$patched"

  run bash "$patched"

  assert_success
  assert_line --partial "CURRENT CACHE SIZE: 10 MB"
  assert_line --partial "DELETED: -30 MB"
  assert_line --partial "REMAINING CACHE SIZE AFTER CLEANUP: 40 MB"

  rm -f "$patched"
}
