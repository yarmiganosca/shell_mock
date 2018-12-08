## ROADMAP 1.0.0

* `IOPopenMonkeyPatch`
* `PTYSpawnMonkeyPatch`
* `OpenMonkeyPatch`
* should `SpawnMonkeyPatch` be 2 patches (`KernelSpawnMonkeyPatch` and `ProcessSpawnMonkeyPatch`)?
* add `CommandStub#will_cause(&blk)` for specifying desired side effects
* add `CommandStub#will_stdout(str)` & `CommandStub#will_stderr(str)`. these will work differently for backtick than it will for system & exec.
* ADD YARD DOCUMENTATION TO METHODS
* maybe add `CommandStub#with_stdin(str)` for `spawn`?
* maybe adding the ability to specify the order in which commands output to stdout vs. stderr (like, a sequence of outputs) would be useful? would definitely be fun to build, not sure how useful it would be though.

## RELEASE 0.7.0

* FEATURE: `#to_output` is an alias of `#and_output`
* FEATURE: `#to_return` is an alias of `#and_return`
* FEATURE: `#to_exit` is an alias of `#and_exit`
* FEATURE: `#to_succeed` is an alias of `#and_succeed`
* FEATURE: `#to_fail` is an alias of `#and_fail`
* DEPRECATION: `#and_output` is deprecated and will be removed in 1.0.0. Use `#to_output` instead.
* DEPRECATION: `#and_return` is deprecated and will be removed in 1.0.0. Use `#to_return` instead.
* DEPRECATION: `#and_exit` is deprecated and will be removed in 1.0.0. Use `#to_exit` instead.
* DEPRECATION: `#and_succeed` is deprecated and will be removed in 1.0.0. Use `#to_succeed` instead.
* DEPRECATION: `#and_fail` is deprecated and will be removed in 1.0.0. Use `#to_fail` instead.

## RELEASE 0.6.0

* FEATURE: use `#and_succeed` to set an invocation's exit status to 0
* FEATURE: use `#and_fail` to set an invocation's exit status to 1
* FIX: `ShellMock.disable` now resets the `let_commands_run` flag, preventing that from carrying between tests

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
