# Characterization recipes — Go

Goal: pin current behavior fast with the standard `testing` package, before
any migration slice.

## Golden files

The idiomatic pattern is golden files with an `-update` flag:

```go
var update = flag.Bool("update", false, "update golden files")

func TestGolden(t *testing.T) {
    got := runThing(input)
    golden := filepath.Join("testdata", t.Name()+".golden")
    if *update {
        os.WriteFile(golden, []byte(got), 0644)
    }
    want, _ := os.ReadFile(golden)
    if got != string(want) {
        t.Errorf("diff (-want +got):\n%s", cmp.Diff(string(want), got))
    }
}
```

Generate goldens from unmodified code (`go test ./... -update`), review the
diff, commit. Requires `github.com/google/go-cmp` for readable diffs.

## Seams and fakes

- Depend on interfaces at the boundary; hand-roll fakes in tests (idiomatic,
  no framework needed).
- HTTP: `net/http/httptest` (server + `httptest.NewRecorder`).
- Time: define a `Clock` interface; fake it in tests.
- Randomness: inject a `*rand.Rand` with a fixed seed.
- FS: `t.TempDir()`.

## Gotchas

- Map iteration order is random: sort keys before output/snapshot.
- Concurrency: synchronize with channels/waitgroups; never `time.Sleep` to
  "wait" — that is a flaky characterization test.
- Error strings: snapshot them; they are behavior.

## Baseline commands

```
go build ./...
go vet ./...
golangci-lint run   # if configured; otherwise go vet
go test ./...       # record pass/fail as the baseline
```
