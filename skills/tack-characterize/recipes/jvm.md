# Characterization recipes — Java / Kotlin (JVM)

Goal: pin current behavior fast with JUnit 5, before any migration slice.

## Approvals / goldens

- Java ApprovalTests (`approvaltests` dependency): `Approvals.verify(output)` —
  approved files live in `src/test/resources/...approved.txt`; approve via
  `*.received.txt` diff.
- Or plain golden files: read `src/test/resources/testdata/x.golden`,
  regenerate with `-Dgolden.update=true`.
- Commit approved files; they are the pinned behavior.

## Seams and fakes

- Time: inject `java.time.Clock` (never `Instant.now()` at the call site).
- HTTP: WireMock or MockWebServer; record once, replay.
- Randomness: inject `java.util.Random` with fixed seed.
- FS: `@TempDir` (JUnit 5).
- DB: Testcontainers for a real DB; snapshot results.

## Gotchas

- HashMap ordering: use `TreeMap`/sorted streams or sort before snapshotting.
- Threads/async: await latches in tests; never `Thread.sleep`.
- Locale/timezone: pin `Locale`/`ZoneId.UTC` in test setup; goldens must not
  embed them.
- Floats/UUIDs: normalize in the verifier.

## Baseline commands

```
./gradlew build -x test        # or mvn compile
./gradlew test                  # record pass/fail as the baseline
./gradlew checkstyleMain spotlessCheck   # if configured
```
