## ROADMAP 1.0.0

* add `CommandStub#with_side_effect(&blk)` for specifying desired side effects
* add `CommandStub#with_stdout(str)` & `CommandStub#with_stderr(str)`. these will work differently for backtick than it will for system & exec.
* maybe add `CommandStub#with_stdin(str)` for `spawn`?
* `and_return` should be `and_output`, which probably gives me a way into the other in/out/err stuff mentioned above

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
