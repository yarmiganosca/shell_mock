## ROADMAP 1.0.0

* convert `CommandStub#and_exit` to `CommandStub#will_exit`
* convert `CommandStub#and_output` to `CommandStub#will_output`
* convert `CommandStub#and_return` to `CommandStub#will_return`
* add `CommandStub#will_cause(&blk)` for specifying desired side effects
* add `CommandStub#will_stdout(str)` & `CommandStub#will_stderr(str)`. these will work differently for backtick than it will for system & exec.
* maybe add `CommandStub#with_stdin(str)` for `spawn`?

## RELEASE 0.5.0

* FEATURE: `CommandStub#and_output` can be used on command stubs to set the output of a command without setting the exit status.
* ENHANCEMENT: `Kernel#spawn`, `Kernel.spawn`, & `Process.spawn` are now implemented well enough that `Open3.capture3` behaves as though spawn is not being monkey-patched when ShellMock is enabled (and therefore, spawn most definitely is being monkey-patched). This should apply to all of `Open3`'s methods, since they all delegate to `Open3.popen_run` or `Open3.pipeline_run`, both of which internally use `Kernel#spawn`, **however I only have a spec for `Open3.capture3`**.

## RELEASE 0.4.0

* FEATURE: `Kernel#spawn` and `Kernel.spawn` are now supported

## RELEASE 0.3.3

* FIX: `exec`'d calls now registered as having been called

## RELEASE 0.3.2

* FIX: fixed patched `exec`'s handling of exit statuses

## RELEASE 0.3.1

* FIX: ``Kernel.` ``, `Kernel.exec`, and `Kernel.system` are now all supported as well. This is useful to testing thor suites that shell out, because thor (for reasons passing understanding) redefines `#exec`, so we have to resort to `Kernel.exec`.

## RELEASE 0.3.0

* FEATURE: you can now stub & mock `Kernel#exec`.

## RELEASE 0.2.2

* FIX: fixed a test ordering bug
